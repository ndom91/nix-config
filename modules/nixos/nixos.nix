{ inputs, config, pkgs, unstablePkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python3.11-youtube-dl-2021.12.17"
    ];
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

  programs = {
    command-not-found.enable = false;
    nix-index-database.comma.enable = true;

    _1password = { enable = true; };
    _1password-gui = {
      enable = true;
      package = unstablePkgs._1password-gui-beta;
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
    # podman = {
    #   defaultNetwork.settings = {
    #     dns_enabled = true;
    #   };
    #   dockerCompat = true;
    #   dockerSocket.enable = true;
    #   enable = true;
    # };
  };
}
