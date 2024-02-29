{ lib, inputs, config, pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../modules/packages/tokyo-night-sddm/default.nix { };
in
{
  imports = with pkgs; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/system-packages.nix
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    autoOptimiseStore = true;
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # make 3.5mm jack work
    # Disable Nvidia GPU
    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
      options snd_hda_intel model=headset-mode
    '';

    blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  };
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';

  networking = {
    hostName = "ndo2";
    useDHCP = lib.mkDefault true;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;

    firewall.enable = false;
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
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
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        theme = "tokyo-night-sddm";
        wayland.enable = true;
        settings = {
          Theme = {
            CursorTheme = "Bibata Ghost";
            # CursorTheme = "Bibata-Modern-Classic";
          };
        };
      };
      gdm = {
        enable = false;
        wayland = true;
      };
    };
    # videoDrivers = [ "amdgpu" ];
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
    # desktopManager.gnome.enable = false;
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
    opengl = {
      extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
    };
    # opengl.enable = true;
    # OpenGL Mesa version pinning - https://github.com/NixOS/nixpkgs/issues/94315#issuecomment-719892849

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };


  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAbAylECwZpvAOEq69apq5J1OAAF3ka TebhuqOps2O7WoJCCylqzu7rrPAun2tE3tsjeqwEdFMjSXYxBQowp5b0HiAT6w1Mtwy6Pg jnQW5/VOsTYpg1dl3hw1ZiRYa1yUT+xfVba4+POEKXizpMjL8xlkW/ugnj2WL8O85QplqI GRRIsSAa4jBsZ3d1j88iSv0ZFpTXdTuf9EISNFBrIXq7f+JyhtGZqaj4m67CNoxPiadfyX 7XrgVKra8/SaYa00RebI4V+tp6NDhJL6LZN8rX2O1a7O6NCUhZ1avYw4aY00kMyGqx2bR5 5ml7jN9k/edaKqHJInff8cPefa45ub ndo@ndo4"
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    # useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Set in home-manager home.nix
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  environment.systemPackages = with pkgs; [
    tokyo-night-sddm
  ];

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
    syncthing = {
      enable = true;
      tray.enable = true;
    };
  };

  powerManagement.enable = true;

  programs = {
    light.enable = true;
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


  # DO NOT TOUCH #
  system.stateVersion = "23.11";
}
