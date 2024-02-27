{ lib, inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/system-packages.nix
    inputs.home-manager.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  networking = {
    hostName = "ndo4";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      gdm = {
        enable = false;
        wayland = false;
      };
    };
    # videoDrivers = [ "amdgpu" ];
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
    desktopManager.gnome.enable = false;
  };

  # systemd services
  systemd.services.systemd-udevd.restartIfChanged = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = false;

  # Enable sound with pipewire.
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };
  security.rtkit.enable = true;

  hardware = {
    enableAllFirmware = true;
    pulseaudio.enable = false;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };


  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bat
    brightnessctl
    coreutils
    difftastic
    docker-compose
    dua
    eza
    fd
    ffmpeg
    file
    fzf
    git
    htop
    ipmitool
    jq
    libnotify
    lm_sensors
    neofetch
    neovim
    nmap
    ouch
    qemu
    ripgrep
    smartmontools
    tmux
    tree
    tree
    unzip
    watch
    wget
    zip
    zoxide
  ];

  # Set in home-manager home.nix
  # programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # FOR LATER: dynamically-linked binaries work-around
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  # ];

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "yes";
    };

    fwupd.enable = true;
    tailscale.enable = true;
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  nix = {
    autoOptimiseStore = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # DO NOT TOUCH #
  system.stateVersion = "23.11";
}
## hardware-configuration.nix options for future
# networking.useDHCP = lib.mkDefault true;
# nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
# hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
# Bluetooth
