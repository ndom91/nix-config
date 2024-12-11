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
    ../../modules/nixos/nixos.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/services/polkit-agent.nix
    ../../modules/nixos/services/tailscale.nix
    ../../modules/nixos/services/ssh.nix
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

    # Disable Nvidia GPU
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
      "172.18.1.110" = [ "www.iceportal.de" "iceportal.de" ];
    };

    wireless.networks."WutangLAN".psk = config.age.secrets.wutangKey.path;
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
    #   videoDrivers = [ "intel" ];
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
  };

  # Hyprland swaynotificationcenter service
  systemd.user.units.swaync.enable = true;

  # systemd services
  systemd.services.systemd-udevd.restartIfChanged = false;
  # rebuild-switch bug - https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1377224366
  systemd.services.NetworkManager-wait-online.enable = false;

  # SuspendEstimationSec defeaults to 1h;
  # HibernateDelaySec defaults to 2h
  # See: https://www.freedesktop.org/software/systemd/man/latest/systemd-sleep.conf.html#Description
  systemd.sleep.extraConfig = ''
    AllowSuspendThenHibernate=yes
  '';

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = { };
    pki.certificateFiles = [
      ./../../dotfiles/certs/puff.lan.crt
      ./../../dotfiles/certs/nextdns.crt
    ];
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "i965";
    # LIBVA_DRIVER_NAME = "iHD";
  };

  hardware = {
    enableAllFirmware = true;
    acpilight.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # Intel Hardware Acceleration 
    graphics = {
      enable = true;
      package = unstablePkgs.mesa.drivers;
      package32 = unstablePkgs.pkgsi686Linux.mesa.drivers;
      # driSupport = true;
      # driSupport32Bit = true;
      extraPackages = with unstablePkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-compute-runtime # 8th gen +
        intel-ocl # up to 7thgen

        # For 8th gen:
        # vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
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
    extraGroups = [ "networkmanager" "wheel" "libvirt" "kvm" "video" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit nix-colors rose-pine-cursor inputs unstablePkgs fira-sans-nerd-font stateVersion; };
    useGlobalPkgs = true;
    users = {
      "ndo" = import ./home.nix;
    };
  };

  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  #   };
  # };

  environment.systemPackages = with pkgs; [
    # tokyo-night-sddm
    # corners-sddm
    cpupower-gui
    powerstat
    rose-pine-cursor
    inputs.nixos-needtoreboot.packages.${pkgs.system}.default
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

    # fprintd.enable = true;
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

  system.stateVersion = stateVersion;
}


