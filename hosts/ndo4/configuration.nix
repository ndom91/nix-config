{ lib, agenix, nix-colors, inputs, unstablePkgs, overlays, config, pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../packages/tokyo-night-sddm/default.nix { };
  corners-sddm = pkgs.libsForQt5.callPackage ../../packages/corners-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  # rose-pine-cursor-hyprcursor = pkgs.callPackage ../../packages/rose-pine-cursor-hyprcursor/default.nix { };
  # flameshot = pkgs.callPackage ../../packages/flameshot/default.nix { };
  # gimp-devel = pkgs.callPackage ../../packages/gimp-devel {
  #   lcms = pkgs.lcms2;
  # };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/nginx.nix
    ../../modules/home-manager/languages/python.nix
    inputs.home-manager.nixosModules.default
  ];

  age.identityPaths = [
    "${config.users.users.ndo.home}/.ssh/id_ndo4"
  ];
  age.secrets.pvpn.file = ../../secrets/pvpn.age;
  age.secrets.ssh = {
    file = ./../../secrets/ssh.age;
    path = "${config.users.users.ndo.home}/.ssh/config";
    owner = "ndo";
    group = "users";
    mode = "644";
  };

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

  # Allow auto-upgrades to happen every day
  # system.autoUpgrade = {
  #   enable = true;
  #   flake = "${config.users.users.hadi.home}/.config/nixos";
  #   flags = ["--update-input" "nixpkgs" "--commit-lock-file"];
  #   # operation = "boot";
  #   dates = "12:00";
  #   allowReboot = false;
  # };

  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 20;
      netbootxyz.enable = true;
    };

    loader.efi.canTouchEfiVariables = true;

    # used by tailscale for exit node
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;

      # Vite large project workarounds - https://vitejs.dev/guide/troubleshooting#requests-are-stalled-forever
      "fs.inotify.max_queued_events" = 16384;
      "fs.inotify.max_user_instances" = 8192;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  networking = {
    hostName = "ndo4";
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
    timeServers = [
      "10.0.0.1"
    ];
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
      ];
      # allowedUDPPorts = [];
    };
    hosts = {
      "127.0.0.1" = [ "localhost" "ndo4" "sveltekasten" "db.puff.lan" ];
      "10.0.0.25" = [ "checkly.pi" "docker-pi" ];
    };
  };

  time.timeZone = "Europe/Berlin";

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
            Font = "Fira Sans";
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
    videoDrivers = [ "amdgpu" ];
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
    # desktopManager.gnome.enable = false;
  };

  # Hyprland swaynotificationcenter service
  systemd.user.units.swaync.enable = true;

  # systemd services
  systemd.services.systemd-udevd.restartIfChanged = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = false;

  # Vite large project workarounds - https://vitejs.dev/guide/troubleshooting#requests-are-stalled-forever
  # See also: https://github.com/NixOS/nixpkgs/issues/159964#issuecomment-1252682060
  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';
  systemd.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';

  # SuspendEstimationSec defeaults to 1h; 
  # HibernateDelaySec defaults to 2h
  # See: https://www.freedesktop.org/software/systemd/man/latest/systemd-sleep.conf.html#Description
  systemd.sleep.extraConfig = ''
    AllowSuspendThenHibernate=yes
  '';

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
    pki.certificateFiles = [
      ./../../dotfiles/certs/puff.lan.crt
      ./../../dotfiles/certs/nextdns.crt
    ];
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
      '';
      mode = "0755";
    };
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  hardware = {
    enableAllFirmware = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # OpenGL Mesa version pinning - https://github.com/NixOS/nixpkgs/issues/94315#issuecomment-719892849
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # amdvlk # Using default radv instead
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

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
    extraSpecialArgs = { inherit nix-colors rose-pine-cursor inputs unstablePkgs; };
    # useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Fira Sans"
          "sans-serif"
        ];
        monospace = [
          "Operator Mono Light"
        ];
        emoji = [
          "Noto Color Emoji"

        ];
      };
    };
    fontDir.enable = true;
  };

  nixpkgs = {
    config = {
      permittedInsecurePackages = [ "electron-25.9.0" ]; # For `unstablePkgs.protonvpn-gui`
      allowUnfree = true;
      vivaldi = {
        proprietaryCodecs = true;
        enableWidevine = true;
      };
    };
  };

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;

  programs._1password = { enable = true; };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ndo" ];
  };

  environment.systemPackages = with pkgs; [
    tokyo-night-sddm
    corners-sddm
    rose-pine-cursor
    # flameshot
    # gimp-devel
  ];

  # FOR LATER: dynamically-linked binaries work-around
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  # ];

  # System Services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
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
      openFirewall = true;
      publish.domain = true;
    };

    fprintd.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    smartd.enable = true;
    irqbalance.enable = true;

    protonvpn = {
      enable = true;
      autostart = false;
      interface = {
        name = "pvpn-wg-nl256";
        dns.enable = false;
        privateKeyFile = config.age.secrets.pvpn.path;
      };
      endpoint = {
        publicKey = "Zee6nAIrhwMYEHBolukyS/ir3FK76KRf0OE8FGtKUnI=";
        ip = "77.247.178.58";
      };
    };
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
      onShutdown = "shutdown";
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
