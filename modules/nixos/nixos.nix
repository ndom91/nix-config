{ inputs, config, pkgs, unstablePkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python3.12-youtube-dl-2021.12.17"
    ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
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

  programs = {
    command-not-found.enable = false;
    nix-index-database.comma.enable = true;

    _1password = { enable = true; };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ndo" ];
    };

    nix-ld = {
      enable = true;
      package = unstablePkgs.nix-ld;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ];
    };

    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    nh = {
      enable = true;
      flake = "/etc/nixos";
      # flake = "/etc/nixos#${config.networking.hostName}";
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

  # Allow 1Password extension <-> app via Vivaldi
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
      '';
      mode = "0755";
    };
  };

  age.identityPaths = [
    "${config.users.users.ndo.home}/.ssh/id_ndo4"
  ];
  age.secrets.openai = {
    file = ../../secrets/openai.age;
    owner = "ndo";
    group = "users";
    mode = "644";
  };
  age.secrets.anthropic = {
    file = ../../secrets/anthropic.age;
    owner = "ndo";
    group = "users";
    mode = "644";
  };
  age.secrets.pvpn_uk = {
    file = ../../secrets/pvpn_uk.age;
    owner = "ndo";
    group = "users";
    mode = "644";
  };
  age.secrets.pvpn_mx = {
    file = ../../secrets/pvpn_mx.age;
    owner = "ndo";
    group = "users";
    mode = "644";
  };
  age.secrets.sshHosts = {
    file = ./../../secrets/sshHosts.age;
    path = "${config.users.users.ndo.home}/.ssh/config";
    owner = "ndo";
    group = "users";
    mode = "644";
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
    # lxd = {
    #   enable = true;
    #   recommendedSysctlSettings = true;
    #   preseed = {
    #     networks = [{
    #       name = "lxdbr0";
    #       type = "bridge";
    #       config = {
    #         "ipv4.address" = "10.0.0.11/24";
    #         "ipv6.address" = "auto";
    #         # "ipv4.nat" = "true";
    #         # "ipv6.address" = "fd42::1/64";
    #       };
    #     }];
    #
    #     storage_pools = [{
    #       name = "default";
    #       driver = "dir";
    #       config.source = "/opt/lxd/default";
    #     }];
    #
    #     profiles = [{
    #       name = "default";
    #       devices.eth0 = {
    #         name = "eth0";
    #         nictype = "bridged";
    #         parent = "lxdbr0";
    #         type = "nic";
    #       };
    #       devices.root = {
    #         path = "/";
    #         pool = "default";
    #         type = "disk";
    #         size = "35GiB";
    #       };
    #     }];
    #   };
    # };
    # lxc = {
    #   enable = true;
    #   lxcfs.enable = true;
    #   defaultConfig = ''
    #     lxc.include = ${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf
    #   '';
    # };
    incus = {
      enable = false;
      ui.enable = true;
      ui.package = pkgs.incus-ui-canonical;
      preseed = {
        config = {
          "core.https_address" = "0.0.0.0:9999";
        };
        networks = [{
          name = "lxdbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.100.2/24";
            "ipv6.address" = "auto";
            "ipv4.nat" = "true";
            # "ipv6.address" = "fd42::1/64";
          };
        }];

        storage_pools = [{
          name = "default";
          driver = "dir";
          config.source = "/opt/lxd/default";
        }];

        profiles = [{
          name = "default";
          devices.eth0 = {
            name = "eth0";
            nictype = "bridged";
            parent = "lxdbr0";
            type = "nic";
          };
          devices.root = {
            path = "/";
            pool = "default";
            type = "disk";
            size = "35GiB";
          };
        }];
      };
    };
  };
}
