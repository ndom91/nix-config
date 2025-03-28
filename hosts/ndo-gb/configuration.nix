{ lib, agenix, nix-colors, inputs, stateVersion, unstablePkgs, config, pkgs, ... }:
let
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  fira-sans-nerd-font = pkgs.callPackage ../../packages/fira-sans-nerd-font/default.nix { };
  binsider = pkgs.callPackage ../../packages/binsider/default.nix { };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/nixos.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/services/polkit-agent.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/default.nix
    ../../modules/nixos/services/ssh.nix
    ../../modules/nixos/services/greetd.nix
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

  powerManagement.enable = true;

  system.stateVersion = stateVersion;

  age.secrets.cbaseKey.file = ../../secrets/cbaseKey.age;
  age.secrets.wutangKey.file = ../../secrets/wutangKey.age;
  age.secrets.derpyKey.file = ../../secrets/derpyKey.age;
  age.secrets.nm-secrets = {
    file = ../../secrets/nm-secrets.age;
    owner = "root";
    group = "root";
  };

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

    # make 3.5mm jack work
    extraModprobeConfig = ''
      options snd_hda_intel model=headset-mode
    '';

    # Support mounting NFS shares
    supportedFilesystems = [ "nfs" ];
  };

  networking = {
    hostName = "ndo-gb";
    domain = "puff.lan";
    useDHCP = lib.mkDefault false;
    # useNetworkd = true;
    # interfaces = {
    #   wlan0.ipv4.addresses = [{ address = "10.0.1.52"; prefixLength = 24; }];
    # };
    networkmanager = {
      enable = true;
      dns = "systemd-resolved"; # 'dnsmasq', 'default', 'systemd-resolved', 'none';
      # https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings-keyfile.html
      # https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings.html
      ensureProfiles = {
        environmentFiles = [
          config.age.secrets.nm-secrets.path
        ];
        profiles = {
          "gitbutler-wifi" = {
            connection = {
              id = "gitbutler-wifi";
              type = "wifi";
            };
            ipv4 = {
              method = "auto";
              nameserver = "192.168.178.2";
              dns-search = "gitbutler.lan";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "Derpy Dino Bronx";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = config.age.secrets.derpyKey.path;
            };
          };
          "WutangLAN_01" = {
            connection = {
              id = "WutangLAN_01";
              type = "wifi";
            };
            ipv4 = {
              method = "manual";
              address1 = "10.0.1.52/24";
              gateway = "10.0.1.1";
              dns = "10.0.1.1;";
              dns-search = "puff.lan;";
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              dns-search = "puff.lan";
              method = "auto";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "WutangLAN";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WUTANGLAN_PSK";
            };
          };
          "c-base-crew" = {
            connection = {
              id = "c-base-crew";
              type = "wifi";
            };
            ipv4 = {
              method = "auto";
              nameserver = "10.0.0.1";
              dns-search = "";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "c-base-crew";
              # hidden = true;
              security = "802-11-wireless-security";
            };
            wifi-security = {
              key-mgmt = "wpa-eap";
              psk = config.age.secrets.cbaseKey.path;
            };
            "802-1x" = {
              eap = "peap";
              identity = "ndo";
              ca-cert = "/etc/ssl/certs/ca-bundle.crt";
              # subject_match = "/CN=radius.cbrp3.c-base.org";
              altsubject-matches = "DNS:radius.cbrp3.c-base.org";
              phase1-peapver = "1";
              phase2-auth = "mschapv2";
              # https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings.html#secrets-flags
              # password-flags = "2"; # 2 = don't save
            };
          };
        };
      };
    };
    nameservers = [
      "10.0.1.1"
    ];
    timeServers = [
      # "10.0.0.1"
      "time.puff.lan"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
    ];
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
      ];
    };
    hosts = {
      "172.18.1.110" = [ "www.iceportal.de" "iceportal.de" ];
    };
  };

  # rebuild-switch bug - https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1377224366
  systemd.services.NetworkManager-wait-online.enable = false;

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
    AllowHiberation=yes
    # Currently on s2idle supported; see `cat /sys/power/mem_sleep`
    # AllowSuspendThenHibernate=yes
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

  hardware = {
    enableAllFirmware = true;
    acpilight.enable = true;
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

    graphics = {
      enable = true;
      extraPackages = with unstablePkgs; [
        intel-media-driver
        intel-compute-runtime

        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "plugdev" "networkmanager" "wheel" "libvirt" "kvm" "video" "render" "dialout" "lxd" "incus-admin" ];
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
    # Quectel RM520N-GL
    # lenovo-wwan
    # modemmanager
    # modem-manager-gui
    # libmbim

    # tokyo-night-sddm
    # corners-sddm
    # binsider # ELF bin analyzer
    # cpupower-gui
    # powerstat
    rose-pine-cursor
    inputs.nixos-needtoreboot.packages.${pkgs.system}.default

    wirelesstools # iwconfig, iwlist, etc.
    opensnitch # network activity monitor / firewall
    opensnitch-ui
    quickemu # Download preconfiged VM qemu configs and ISOs

    # 3D Printing
    # bambu-studio
    orca-slicer
  ];


  console = {
    earlySetup = true;
    colors = [
      "000000"
      "FC618D"
      "7BD88F"
      "FD9353"
      "5AA0E6"
      "948AE3"
      "5AD4E6"
      "F7F1FF"
      "99979B"
      "FB376F"
      "4ECA69"
      "FD721C"
      "2180DE"
      "7C6FDC"
      "37CBE1"
      "FFFFFF"
    ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    light.enable = true;
    adb.enable = true;
    kdeconnect.enable = false; # TODO: Wasn't connecting to ndo-op9
  };

  # System Services
  services = {
    displayManager = {
      defaultSession = "hyprland";
    };
    envfs.enable = true;
    libinput.touchpad = {
      tappingButtonMap = "lrm";
    };

    dbus.implementation = "broker";
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    gnome.gnome-keyring.enable = true;

    opensnitch.enable = true;
    picosnitch.enable = false;

    protonvpn = {
      enable = true;
      autostart = false;
      interface = {
        ip = "10.2.0.2/32";
        # privateKeyFile = config.age.secrets.pvpn_uk.path;
        privateKeyFile = config.age.secrets.pvpn_mx.path;
      };
      endpoint = {
        # ip = "77.247.178.58"; # UK
        # publicKey = "Zee6nAIrhwMYEHBolukyS/ir3FK76KRf0OE8FGtKUnI="; # UK
        ip = "138.199.50.107"; # MX
        publicKey = "tHwmpVZsh4yfoA9/vWbacF6cWcXUKE9wuDP5bz66oh8="; # MX
      };
    };

    resolved = {
      enable = true;
      llmnr = "false";
      domains = [
        "puff.lan"
      ];
      fallbackDns = [ ];
      # [] = none
      # null = upstream defauls
    };

    fwupd.enable = true;
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
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      browseDomains = [
        "puff.lan"
      ];
    };

    fprintd.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    smartd.enable = true;
    irqbalance.enable = true;
    blueman.enable = true;

    # Laptop Specific
    logind = {
      lidSwitch = "suspend-then-hibernate";
    };
    thermald.enable = true;
    # upower.enable = true;

    tlp = {
      enable = true;
      settings = {
        # https://discourse.nixos.org/t/nixos-power-management-help-usb-doesnt-work/9933/2
        # sudo tlp-stat to see current and possbile values

        # CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
        START_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 95;
        TLP_DEFAULT_MODE = "BAT";
        # Tell tlp to always run in default mode
        # TLP_PERSISTENT_DEFAULT = 1;
        # INTEL_GPU_MIN_FREQ_ON_AC = 500;
        # INTEL_GPU_MIN_FREQ_ON_BAT = 500;

        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # Don't autosuspend USB devices (Dell Monitor -> Input Devices)
        USB_AUTOSUSPEND = 0;
        # USB_EXCLUDE_WWAN = 1;
        USB_DENYLIST = "3434:0820 046d:c548"; # Keychron Q2 Max + Logitech Bolt Receiver
      };
    };
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
        # { appId = "com.bambulab.BambuStudio"; origin = "flathub"; }
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
  # systemd.targets.graphical = {
  #   wants = [ "network-online.target" ];
  #   after = [ "network-online.target" ];
  # };
  # Ensure network is online before starting these services
  systemd.services.clamav-freshclam = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
  systemd.services.flatpak-managed-install = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

  # TODO: systemd-resolved seems to need restarted after every fresh boot once I make it to `graphical-session.target`.
  # I've noticed that if I run `resolvectl status` at that point, it errors on getting link details for all interfaces other
  # than the primary wlp0s20f3 wifi interface, i.e. tailscale, docker bridge, etc. However, I can't resolve anything from
  # any interface. Even though `Global` and the `wl...` interface seem correctly set up.
  # systemd.targets.network-online = {
  #   wantedBy = [ "systemd-resolved.service" "clamav-freshclam.service" ];
  # };
}
