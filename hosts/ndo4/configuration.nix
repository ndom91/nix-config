{ lib, agenix, nix-colors, inputs, stateVersion, unstablePkgs, config, pkgs, ... }:
let
  # tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../packages/tokyo-night-sddm/default.nix { };
  # corners-sddm = pkgs.libsForQt5.callPackage ../../packages/corners-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  fira-sans-nerd-font = pkgs.callPackage ../../packages/fira-sans-nerd-font/default.nix { };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/nixos.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/services/polkit-agent.nix
    ../../modules/nixos/services/nginx.nix
    ../../modules/nixos/services/default.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/ssh.nix
    ../../modules/nixos/services/greetd.nix
    ../../modules/nixos/services/v4l2loopback.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/languages/python.nix
    ../../modules/home-manager/languages/node.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  nix = {
    settings = {
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
    };
  };

  system.stateVersion = stateVersion;

  ndom91 = {
    thunar.enable = true;
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      netbootxyz.enable = true;
    };

    loader.efi.canTouchEfiVariables = true;

    kernel.sysctl = {
      # used by tailscale for exit node
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };


  # Networking
  networking = {
    hostName = "ndo4";
    useNetworkd = true;
    useDHCP = false;
    domain = "puff.lan";
    # networkmanager.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
      ];
    };
    timeServers = [
      "time.puff.lan"
    ];
  };

  # rebuild-switch bug - https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1377224366
  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp42s0";
      address = [
        "10.0.0.10/24"
      ];
      dns = [ "10.0.0.1" ];
      gateway = [ "10.0.0.1" ];
      ntp = [ "10.0.0.1" ];
      domains = [ "puff.lan" ];
      routes = [
        { Gateway = "10.0.0.1"; }
      ];
      # make the routes on this interface a dependency for network-online.target
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
        IPv6AcceptRA = true;
      };
      ipv6PrefixDelegationConfig = {
        # Let networkd know that we would very much like to use DHCPv6
        # to obtain the "managed" information. Not sure why they can't
        # just take that from the upstream RAs.
        Managed = true;
      };
    };
  };

  # Hyprland swaynotificationcenter service
  systemd.user.units.swaync.enable = true;
  systemd.services."flatpak-managed-install" = {
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
    };
  };

  # SuspendEstimationSec defeaults to 1h;
  # HibernateDelaySec defaults to 2h
  # See: https://www.freedesktop.org/software/systemd/man/latest/systemd-sleep.conf.html#Description
  systemd.sleep.extraConfig = ''
    AllowSuspendThenHibernate=yes
    SuspendState=mem
  '';

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = {
      enableGnomeKeyring = true;
      # allow wayland lockers to unlock the screen
      text = "auth include login";
    };
    pki.certificateFiles = [
      ./../../dotfiles/certs/puff.lan.crt
      ./../../dotfiles/certs/nextdns.crt
    ];
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    # VDPAU_DRIVER = "radeonsi";
    # LIBVA_DRIVER_NAME = "radeonsi";
    # AMD_VULKAN_ICD = "RADV"; # "RADV" | "AMDVLK(?)"
    # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  hardware = {
    enableAllFirmware = true;
    keyboard.qmk.enable = true;
    keyboard.zsa.enable = true;
    flipperzero.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # settings = {
      #   General = {
      #     Experimental = true;
      #   };
      # };
    };

    amdgpu = { opencl.enable = true; }; # ROCM Support

    graphics = {
      enable = true;
    };

    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "kvm" "video" "render" "dialout" "plugdev" "lxd" "incus-admin" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit nix-colors rose-pine-cursor inputs unstablePkgs fira-sans-nerd-font stateVersion; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    # tokyo-night-sddm # SDDM Theme
    # corners-sddm # SDDM Theme
    rose-pine-cursor # Hyprcursor rose-pine theme
    logitech-udev-rules # Solaar
    lact # AMDGPU Controller
    inputs.nixos-needtoreboot.packages.${pkgs.system}.default

    opensnitch
    opensnitch-ui

    quickemu # Download preconfiged VM qemu configs and ISOs
    # bambu-studio # unstable version is Broken 05.01.25

    bottles # Wine Manager
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  # System Services
  services = {
    # xserver.enable = true;
    displayManager = {
      defaultSession = "hyprland";
    };

    dbus.implementation = "broker";
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    gnome.gnome-keyring.enable = true;
    envfs.enable = true;
    protonvpn = {
      enable = true;
      autostart = false;
      interface = {
        ip = "10.2.0.2/32";
        privateKeyFile = config.age.secrets.pvpn_uk.path;
      };
      endpoint = {
        ip = "77.247.178.58";
        publicKey = "Zee6nAIrhwMYEHBolukyS/ir3FK76KRf0OE8FGtKUnI=";
      };
    };

    resolved = {
      enable = true;
      domains = [
        "puff.lan"
      ];
      fallbackDns = [ ];
      # [] = none
      # null = upstream defauls
    };

    # picosnitch.enable = true;
    opensnitch.enable = true;

    # gnome.gnome-keyring.enable = true;

    fwupd.enable = true;
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
    pipewire = {
      enable = true;
      # alsa.enable = true;
      # alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
        # "bluez5.codecs" = "[sbc sbc_xq]";
        # "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };
    avahi = {
      enable = true;
      domainName = "puff.lan";
      browseDomains = [
        "local"
        "puff.lan"
      ];
      nssmdns4 = true;
      # openFirewall = true;
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
    };

    # My Elan reader still not supported
    fprintd = {
      enable = false;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-elan;
      };
    };
    printing.enable = true;
    fstrim.enable = true;
    smartd.enable = true;
    irqbalance.enable = true;
    blueman.enable = true;

    flatpak = {
      enable = true;
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        { appId = "org.gimp.GIMP"; origin = "flathub-beta"; } # Gimp 2.99
        { appId = "com.bambulab.BambuStudio"; origin = "flathub"; }
        { appId = "io.gitlab.azymohliad.WatchMate"; origin = "flathub"; }
        { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
      ];
      overrides = {
        global = {
          # Force Wayland by default
          Context.sockets = [ "wayland" "!x11" "!fallback-x11" ];

          Environment = {
            # Fix un-themed cursor in some Wayland apps
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

            # Force correct theme for some GTK apps
            GTK_THEME = "Adwaita:dark";
          };
        };
      };
    };
  };

  # Ensure network is online before desktop starts
  systemd.targets.graphical = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
