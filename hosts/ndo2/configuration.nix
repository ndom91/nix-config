# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ lib, inputs, config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/system-packages.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  xdg.portal = {
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      sddm = {
        default = [
          "hyprland"
        ];
      };
    };
    enable = true;
    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    libinput.enable = true;
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


  # Enable touchpad support (enabled default in most desktopManager).

  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # environment.systemPackages = with pkgs; [
  #   bat
  #   brightnessctl
  #   coreutils
  #   difftastic
  #   docker-compose
  #   dua
  #   eza
  #   fd
  #   ffmpeg
  #   file
  #   fzf
  #   git
  #   htop
  #   ipmitool
  #   jq
  #   libnotify
  #   lm_sensors
  #   neofetch
  #   neovim
  #   nmap
  #   ouch
  #   qemu
  #   ripgrep
  #   smartmontools
  #   tmux
  #   tree
  #   tree
  #   unzip
  #   watch
  #   wget
  #   zip
  #   zoxide
  # ];

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
    logind = {
      lidSwitch = "suspend";
      extraConfig = "IdleAction=lock";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;
  };

  powerManagement.enable = true;

  programs = {
    light.enable = true;
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
