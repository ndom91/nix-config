{ lib, agenix, nix-colors, inputs, stateVersion, unstablePkgs, overlays, config, pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../packages/tokyo-night-sddm/default.nix { };
  corners-sddm = pkgs.libsForQt5.callPackage ../../packages/corners-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  fira-sans-nerd-font = pkgs.callPackage ../../packages/fira-sans-nerd-font/default.nix { };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/wireguard.nix
    ../../modules/nixos/nixos.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/services/polkit-agent.nix
    ../../modules/nixos/services/nginx.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/languages/python.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 20;
      netbootxyz.enable = true;
    };

    loader.efi.canTouchEfiVariables = true;

    kernel.sysctl = {
      # used by tailscale for exit node
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;

      # Vite large project workarounds - https://vitejs.dev/guide/troubleshooting#requests-are-stalled-forever
      "fs.inotify.max_queued_events" = 16384;
      "fs.inotify.max_user_instances" = 8192;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  services = {
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        # package = unstablePkgs.kdePackages.sddm;
        theme = "corners";
        wayland.enable = true;
        settings = {
          Theme = {
            Font = "Noto Sans";
            EnableAvatars = true;
            CursorTheme = "BreezeX-RosePine-Linux";
            FacesDir = "/etc/nixos/dotfiles/faces";
          };
        };
      };
    };
    xserver = {
      videoDrivers = [ "amdgpu" ];
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };
    envfs.enable = true;
  };

  # Networking
  networking = {
    hostName = "ndo4";
    useNetworkd = true;
    useDHCP = false;
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
    hosts = {
      "127.0.0.1" = [ "localhost" "ndo4" "sveltekasten" ];
      "10.0.0.25" = [ "checkly.pi" "docker-pi" ];
    };
  };

  systemd.services.systemd-udevd.restartIfChanged = false;
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
        { routeConfig.Gateway = "10.0.0.1"; }
      ];
      # make the routes on this interface a dependency for network-online.target
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # Hyprland swaynotificationcenter service
  systemd.user.units.swaync.enable = true;

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
    SuspendState=mem
  '';

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock.text = "auth include login";
    pki.certificateFiles = [
      ./../../dotfiles/certs/puff.lan.crt
      ./../../dotfiles/certs/nextdns.crt
    ];
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
    # AMD_VULKAN_ICD = "RADV"; # "RADV" | "AMDVLK(?)"
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  hardware = {
    enableAllFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # settings = {
      #   General = {
      #     Experimental = true;
      #   };
      # };
    };

    # OpenGL Mesa version pinning - https://github.com/NixOS/nixpkgs/issues/94315#issuecomment-719892849
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      package = unstablePkgs.mesa.drivers;
      package32 = unstablePkgs.pkgsi686Linux.mesa.drivers;
      extraPackages = with unstablePkgs; [
        # amdvlk # Using default radv instead
        libglvnd
        vaapiVdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs; [
        # unstablePkgs.driversi686Linux.amdvlk
      ];
    };

    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/ndom91.keys";
        sha256 = "PfSNkhnNXUR9BTD2+0An2ugQAv2eYipQOFxQ3j8XD5Y=";
      }))
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit nix-colors rose-pine-cursor inputs unstablePkgs fira-sans-nerd-font stateVersion; };
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    tokyo-night-sddm
    corners-sddm
    rose-pine-cursor
    logitech-udev-rules
    inputs.nixos-needtoreboot.packages.${pkgs.system}.default
  ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  # System Services
  services = {
    protonvpn = {
      enable = true;
      autostart = false;
      interface = {
        ip = "10.2.0.2/32";
        privateKeyFile = config.age.secrets.pvpn.path;
      };
      endpoint = {
        ip = "77.247.178.58";
        publicKey = "Zee6nAIrhwMYEHBolukyS/ir3FK76KRf0OE8FGtKUnI=";
      };
    };
    openssh = {
      enable = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    resolved = {
      enable = true;
      domains = [
        "puff.lan"
      ];
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

    gnome.gnome-keyring.enable = true;

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
    # fprintd.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    smartd.enable = true;
    irqbalance.enable = true;
    blueman.enable = true;

    flatpak = {
      enable = true;
      # uninstallUnmanagedPackages = true;
      remotes = lib.mkOptionDefault [{
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }];
      packages = [
        { appId = "org.gimp.GIMP"; origin = "flathub-beta"; } # Gimp 2.99
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

  system.stateVersion = stateVersion;
}
