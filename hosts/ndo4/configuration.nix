{ lib, inputs, unstablePkgs, overlays, config, pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../modules/packages/tokyo-night-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../modules/packages/rose-pine-cursor/default.nix { };
  corners-sddm = pkgs.libsForQt5.callPackage ../../modules/packages/corners-sddm/default.nix { };
in
{
  imports = with pkgs; [
    ./hardware-configuration.nix
    ../common/system.nix
    ../common/languages/python.nix
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      netbootxyz.enable = true;
    };

    loader.efi.canTouchEfiVariables = true;

    # used by tailscale for exit node
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

  networking = {
    hostName = "ndo4";
    # useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    nameservers = [
      "10.0.0.1"
    ];
    interfaces = {
      enp42s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.0.0.10";
            prefixLength = 24;
          }];
        };
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp42s0";
    };

    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
      ];
      # allowedUDPPorts = [];
    };
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

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        theme = "corners";
        wayland.enable = true;
        settings = {
          Theme = {
            Font = "Ubuntu Nerd Font";
            EnableAvatars = true;
            CursorTheme = "BreezeX-RosePine-Linux";
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
    enable = false;
    mediaKeys = {
      enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  hardware = {
    enableAllFirmware = true;
    # enableRedistributableFirmware = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    opengl.enable = true;
    # OpenGL Mesa version pinning - https://github.com/NixOS/nixpkgs/issues/94315#issuecomment-719892849

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
    extraSpecialArgs = { inherit rose-pine-cursor inputs unstablePkgs; };
    # useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    vivaldi = {
      proprietaryCodecs = true;
      enableWidevine = true;
    };
  };
  nixpkgs.overlays = overlays;

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  programs._1password = { enable = true; };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ndo" ];
  };

  environment.systemPackages = with pkgs; [
    tokyo-night-sddm
    corners-sddm
    rose-pine-cursor
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
    gnome.gnome-keyring.enable = true;

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
      wireplumber.enable = true;
    };
    # Gnome Remote Desktop support via pipewire
    # gnome.gnome-remote-desktop.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };

    fprintd.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    fstrim.enable = true;
  };

  programs = {
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
    };
    # spiceUSBRedirection.enable = true;
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
