{ lib, agenix, nix-colors, inputs, unstablePkgs, config, pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../packages/tokyo-night-sddm/default.nix { };
  corners-sddm = pkgs.libsForQt5.callPackage ../../packages/corners-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  fira-sans-nerd-font = pkgs.callPackage ../../packages/fira-sans-nerd-font/default.nix { };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/services/polkit-agent.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/languages/python.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  age.identityPaths = [
    "${config.users.users.ndo.home}/.ssh/id_ndo4"
  ];
  # age.secrets.cbaseKey.file = ../../secrets/cbaseKey.age;
  age.secrets.pvpn.file = ../../secrets/pvpn.age;
  age.secrets.wutang.file = ../../secrets/wutang.age;
  age.secrets.derpyKey.file = ../../secrets/derpyKey.age;
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
      options = "--delete-older-than 5d";
    };
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

    kernel.sysctl = {
      # Vite large project workarounds - https://vitejs.dev/guide/troubleshooting#requests-are-stalled-forever
      "fs.inotify.max_queued_events" = 16384;
      "fs.inotify.max_user_instances" = 8192;
      "fs.inotify.max_user_watches" = 524288;
    };
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
            psk = config.age.secrets.wutang.path;
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
      "127.0.0.1" = [ "localhost" "ndo4" "sveltekasten" "db.puff.lan" ];
      "10.0.0.25" = [ "checkly.pi" "docker-pi" ];
    };

    # TODO: Test Crew Wifi Config
    wireless.networks."c-base-crew" = {
      hidden = true;
      auth = ''
        ssid="c-base-crew"
        key_mgmt=WPA-EAP
        eap=PEAP
        identity="ndo"
        ca_cert="/etc/ssl/certs/ca-bundie.crt"
        subject_match="/CN=radius.cbrp3.c-base.org"
        phase2="auth=MSCHAPV2"
      '';
    };
    # wireless.networks."c-base-crew".psk = config.age.secrets.cbaseKey.path;
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

  services = {
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        # package = unstablePkgs.libsForQt5.sddm;
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
      # enable = true;
      videoDrivers = [ "xe" "intel" ];
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };
    libinput.touchpad = {
      tappingButtonMap = "lrm";
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
  '';

  security = {
    rtkit.enable = true;
    pam.services.swaylock.text = "auth include login";
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

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
      '';
      mode = "0755";
    };
  };

  hardware = {
    enableAllFirmware = true;
    acpilight.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # Intel Hardware Acceleration
    opengl = {
      enable = true;
      package = pkgs.mesa.drivers;
      package32 = pkgs.pkgsi686Linux.mesa.drivers;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with unstablePkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiVdpau
        libvdpau-va-gl
        # intel-compute-runtime # 8th gen +
      ];
    };

    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
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
    extraSpecialArgs = { inherit nix-colors rose-pine-cursor inputs unstablePkgs fira-sans-nerd-font; };
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-25.9.0" ]; # For `unstablePkgs.protonvpn-gui`
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  environment.systemPackages = with pkgs; [
    # Quectel RM520N-GL 
    modemmanager
    modem-manager-gui
    libqmi
    uqmi
    libmbim

    cpupower-gui
    powerstat
    tokyo-night-sddm
    corners-sddm
    rose-pine-cursor
  ];

  programs = {
    hyprland.enable = true;
    hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    _1password = { enable = true; };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ndo" ];
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ];
    };
    fuse.userAllowOther = true;
    light.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # System Services
  services = {
    openssh = {
      enable = true;
      settings = {
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
    upower.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 95;
        # Tell tlp to always run in battery mode
        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;

        # Don't autosuspend USB devices (Dell Monitor -> Input Devices)
        USB_AUTOSUSPEND = 0;
        USB_EXCLUDE_WWAN = 1;

        # Don't autosuspend USB devices (Dell Monitor -> Input Devices)
        # https://discourse.nixos.org/t/nixos-power-management-help-usb-doesnt-work/9933/2
        # USB_AUTOSUSPEND = 0;
        # RUNTIME_PM_BLACKLIST = "06:00.3 06:00.4";
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
  };

  powerManagement.enable = true;

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

  system.stateVersion = "24.05";
}


