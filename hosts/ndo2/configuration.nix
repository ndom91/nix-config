{ lib, agenix, nix-colors, inputs, unstablePkgs, config, pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../packages/tokyo-night-sddm/default.nix { };
  corners-sddm = pkgs.libsForQt5.callPackage ../../packages/corners-sddm/default.nix { };
  rose-pine-cursor = pkgs.callPackage ../../packages/rose-pine-cursor/default.nix { };
  fira-sans-nerd-font = pkgs.callPackage ../../packages/fira-sans-nerd-font/default.nix { };
  # gimp-devel = pkgs.callPackage ../../modules/packages/gimp-devel {
  #   lcms = pkgs.lcms2;
  # };
in
{
  imports = with agenix pkgs; [
    ./hardware-configuration.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/home-manager/languages/python.nix
    inputs.home-manager.nixosModules.default
  ];

  age.identityPaths = [
    "${config.users.users.ndo.home}/.ssh/id_ndo4"
  ];
  # age.secrets.cbaseKey.file = ../../secrets/cbaseKey.age;
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
      options = "--delete-older-than 5d";
    };
  };

  boot = {
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
    networkmanager.enable = true;
    nameservers = [
      "10.0.0.1"
    ];
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
    wireless.networks."c-base-crew".psk = config.age.secrets.cbaseKey.path;
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
            Font = "SFProDisplay Nerd Font";
            EnableAvatars = true;
            CursorTheme = "BreezeX-RosePine-Linux";
            FacesDir = "/etc/nixos/dotfiles/faces";
          };
        };
      };
      gdm = {
        enable = false;
        wayland = true;
      };
    };
    videoDrivers = [ "intel" ];
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
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

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "va_gl";
    # LIBVA_DRIVER_NAME = "i965";
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
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # For 8th gen:
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)

        intel-ocl # up to 7thgen
        intel-compute-runtime # 8th gen + 

        amdvlk
        # intel-vaapi-driver # ?
        # intel-gmmlib ?

        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  users.users.ndo = {
    isNormalUser = true;
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAbAylECwZpvAOEq69apq5J1OAAF3ka TebhuqOps2O7WoJCCylqzu7rrPAun2tE3tsjeqwEdFMjSXYxBQowp5b0HiAT6w1Mtwy6Pg jnQW5/VOsTYpg1dl3hw1ZiRYa1yUT+xfVba4+POEKXizpMjL8xlkW/ugnj2WL8O85QplqI GRRIsSAa4jBsZ3d1j88iSv0ZFpTXdTuf9EISNFBrIXq7f+JyhtGZqaj4m67CNoxPiadfyX 7XrgVKra8/SaYa00RebI4V+tp6NDhJL6LZN8rX2O1a7O6NCUhZ1avYw4aY00kMyGqx2bR5 5ml7jN9k/edaKqHJInff8cPefa45ub ndo@ndo2"
    ];
    packages = [
      fira-sans-nerd-font
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
          "SFProDisplay Nerd Font"
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

  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-25.9.0" ]; # For `unstablePkgs.protonvpn-gui`
    allowUnfree = true;
    # vivaldi = {
    #   proprietaryCodecs = true;
    #   enableWidevine = true;
    # };
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  environment.systemPackages = with pkgs; [
    cpupower-gui
    powerstat
    tokyo-night-sddm
    corners-sddm
    rose-pine-cursor
    fira-sans-nerd-font
    # gimp-devel
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
    command-not-found.enable = true;
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
      nssmdns = true;
      openFirewall = true;
    };

    flatpak.enable = true;
    fprintd.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    smartd.enable = true;
    irqbalance.enable = true;

    # protonvpn = {
    #   enable = true;
    #   autostart = false;
    #   interface = {
    #     name = "pvpn-wg-nl256";
    #     dns.enable = false;
    #     privateKeyFile = config.age.secrets.pvpn.path;
    #   };
    #   endpoint = {
    #     publicKey = "Zee6nAIrhwMYEHBolukyS/ir3FK76KRf0OE8FGtKUnI=";
    #     ip = "77.247.178.58";
    #   };
    # };

    # Laptop Specific
    logind = {
      lidSwitch = "suspend";
      extraConfig = "IdleAction=lock";
    };
    thermald.enable = true;

    tlp = {
      enable = true;
      # ---------------------------------------------------------------------
      # Use this instead if laptop runs HOT under tlp
      # Tell tlp to always run in battery mode
      # ---------------------------------------------------------------------
      #  settings = {
      #    TLP_DEFAULT_MODE = "BAT";
      #    TLP_PERSISTENT_DEFAULT = 1;
      #  };
    };
  };

  powerManagement.enable = true;

  programs = {
    fuse.userAllowOther = true;
    light.enable = true;
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

  system.stateVersion = "23.11";
}

