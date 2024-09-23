{ lib, agenix, nix-colors, inputs, stateVersion, unstablePkgs, config, pkgs, ... }:
let
  # tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../packages/tokyo-night-sddm/default.nix { };
  # corners-sddm = pkgs.libsForQt5.callPackage ../../packages/corners-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  fira-sans-nerd-font = pkgs.callPackage ../../packages/fira-sans-nerd-font/default.nix { };
  lenovo-wwan = pkgs.callPackage ../../packages/lenovo-wwan/default.nix { };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/nixos.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/services/polkit-agent.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/ssh.nix
    ../../modules/nixos/services/greetd.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/languages/python.nix
    ../../modules/home-manager/languages/node.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # age.secrets.cbaseKey.file = ../../secrets/cbaseKey.age;
  age.secrets.wutangKey.file = ../../secrets/wutangKey.age;
  age.secrets.derpyKey.file = ../../secrets/derpyKey.age;

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
  };

  networking = {
    hostName = "ndo-gb";
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      ensureProfiles.profiles = {
        "gitbutler-wifi" = {
          connection = {
            id = "gitbutler-wifi";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
            nameserver = "192.168.188.1";
            dns-search = "";
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
        "WutangLAN" = {
          connection = {
            id = "WutangLAN";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
            nameserver = "10.0.0.1";
            dns-search = "puff.lan";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "WutangLAN";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = config.age.secrets.wutangKey.path;
          };
        };
        # "c-base-crew" = {
        #   connection = {
        #     id = "c-base-crew";
        #     type = "wifi";
        #   };
        #   ipv4 = {
        #     method = "auto";
        #     nameserver = "10.0.0.1";
        #     dns-search = "puff.lan";
        #   };
        #   wifi = {
        #     mode = "infrastructure";
        #     ssid = "c-base-crew";
        #   };
        #   wifi-security = {
        #     key-mgmt = "wpa-eap";
        #     psk = config.age.secrets.cbaseKey.path;
        #   };
        # };
      };
    };
    nameservers = [
      "10.0.0.1"
      "1.1.1.1"
    ];
    timeServers = [
      "10.0.0.1"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
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
      "127.0.0.1" = [ "ndo-gb.puff.lan" "ndo-gb" "localhost" ];
      "172.18.1.110" = [ "www.iceportal.de" "iceportal.de" ];
    };

    # TODO: Test Crew Wifi Config
    # wireless.networks."c-base-crew" = {
    #   hidden = true;
    #   auth = ''
    #     ssid="c-base-crew"
    #     key_mgmt=WPA-EAP
    #     eap=PEAP
    #     identity="ndo"
    #     ca_cert="/etc/ssl/certs/ca-bundie.crt"
    #     subject_match="/CN=radius.cbrp3.c-base.org"
    #     phase2="auth=MSCHAPV2"
    #   '';
    # };
    # wireless.networks."c-base-crew".psk = config.age.secrets.cbaseKey.path;
  };

  services = {
    displayManager = {
      defaultSession = "hyprland";
    };
    # xserver = {
    #   # enable = true;
    #   videoDrivers = [ "xe" "intel" ];
    #   xkb = {
    #     layout = "us";
    #     variant = "";
    #     options = "caps:escape";
    #   };
    # };
    envfs.enable = true;
    libinput.touchpad = {
      tappingButtonMap = "lrm";
    };
    dbus.implementation = "broker";
  };

  # Hyprland swaynotificationcenter service
  systemd.user.units.swaync.enable = true;

  # rebuild-switch bug - https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1377224366
  systemd.services.NetworkManager-wait-online.enable = false;

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
    };
    pki.certificateFiles = [
      ./../../dotfiles/certs/puff.lan.crt
      ./../../dotfiles/certs/nextdns.crt
    ];
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware = {
    enableAllFirmware = true;
    acpilight.enable = true;

    keyboard.qmk.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # Intel Hardware Acceleration
    opengl = {
      enable = true;
      package = unstablePkgs.mesa.drivers;
      package32 = unstablePkgs.pkgsi686Linux.mesa.drivers;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with unstablePkgs; [
        intel-media-driver
        intel-compute-runtime

        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    # TODO: Change to this for >= 24.11
    #hardware
    #  graphics = {
    #    enable = true;
    #    enable32Bit = lib.mkForce isInstall;
    #  };
    #};

    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" "video" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit nix-colors rose-pine-cursor inputs unstablePkgs fira-sans-nerd-font stateVersion; };
    useGlobalPkgs = true;
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
    cpupower-gui
    powerstat
    rose-pine-cursor
    inputs.nixos-needtoreboot.packages.${pkgs.system}.default

    wirelesstools
    opensnitch
    opensnitch-ui
  ];

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    light.enable = true;
  };

  # System Services
  services = {
    opensnitch.enable = true;
    protonvpn = {
      enable = true;
      autostart = false;
      interface = {
        ip = "10.2.0.2/32";
        privateKeyFile = config.age.secrets.pvpnKey.path;
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
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      domainName = "puff.lan";
      browseDomains = [
        "local"
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
      # uninstallUnmanagedPackages = true;
      remotes = lib.mkOptionDefault [{
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }];
      packages = [
        { appId = "org.gimp.GIMP"; origin = "flathub-beta"; } # Gimp 2.99
      ];
    };
    picosnitch = {
      enable = false;
    };
  };

  powerManagement.enable = true;

  system.stateVersion = stateVersion;
}


