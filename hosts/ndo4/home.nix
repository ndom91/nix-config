{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, config, pkgs, unstablePkgs, stateVersion, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    inputs.catppuccin.homeModules.catppuccin
    # inputs.nixcord.homeManagerModules.nixcord
    nix-colors.homeManagerModules.default
    ../../modules/home-manager
  ];

  home = {
    username = "ndo";
    homeDirectory = "/home/ndo";
    stateVersion = stateVersion;
    packages = [
      inputs.home-manager.packages.${pkgs.system}.home-manager # home-manager binary
      fira-sans-nerd-font
    ];
  };

  # systemd.user.sessionVariables = config.home.sessionVariables;
  systemd.user.startServices = "sd-switch";

  # Themes - https://github.com/tinted-theming/base16-schemes
  colorScheme = nix-colors.colorSchemes.rose-pine;

  # ndo4 overrides
  wayland.windowManager.hyprland = {
    settings = {
      monitor = lib.mkForce [
        "DP-1,3440x1440,1080x480,1"
        "DP-2,1920x1080,0x0,1,transform,3"
      ];
      render = {
        direct_scanout = true;

        # Fixes some apps stuttering (xournalpp, hyprlock). Possibly an amdgpu bug
        allow_early_buffer_release = true;
        # explicit_sync = 0;
        # explicit_sync_kms = 0;
      };
      workspace = [
        "1,monitor:DP-2,default:true"
        "2,monitor:DP-1,default:true"
        "3,monitor:DP-1"
      ];
    };
  };

  services = {
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };

  programs.home-manager.enable = true;
}
