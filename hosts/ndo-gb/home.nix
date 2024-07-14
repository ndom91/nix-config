{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, stateVersion, config, pkgs, unstablePkgs, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    nix-colors.homeManagerModules.default
    # User Packages
    ../../modules/home-manager/user-packages.nix
    # Programming Lanaguages
    ../../modules/home-manager/languages/node.nix
    ../../modules/home-manager/languages/rust.nix
    # Common
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/neofetch.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/gtk/default.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/wayland/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = stateVersion;
  home.packages = [
    inputs.home-manager.packages.x86_64-linux.home-manager # home-manager binary
    fira-sans-nerd-font
  ];

  # systemd.user.sessionVariables = config.home.sessionVariables;
  systemd.user.startServices = "sd-switch";

  # Themes - https://github.com/tinted-theming/base16-schemes
  colorScheme = nix-colors.colorSchemes.rose-pine;

  # ndo-gb overrides
  wayland.windowManager.hyprland = {
    settings = {
      monitor = lib.mkForce [
        "eDP-1,preferred,auto,1"
        "DP-2,preferred,auto,1"
      ];
      workspace = [
        "1,monitor:eDP-1,default:true"
        "2,monitor:eDP-1"
        "3,monitor:DP-2,default:true"
      ];
      exec-once = [
        "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1.5"
      ];
      bindl = [
        # trigger when the switch is turning on
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,disable'"
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,preferred,auto,1'"
      ];
      bind = [
        ",XF86Launch2, exec, /home/ndo/.config/rofi/bin/screenshot"
      ];
      input = {
        touchpad = {
          clickfinger_behavior = true;
        };
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 200;
        workspace_swipe_create_new = false;
      };
    };
  };

  home.file = {
    ".ripgreprc".source = ../../dotfiles/.ripgreprc;
    ".local/share/fonts" = {
      recursive = true;
      source = ./../../dotfiles/fonts;
    };

    ".config/hypr/wallpaper.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;

    ".config/brave-flags.conf".source = ../../dotfiles/brave-flags.conf;
    ".config/electron-flags.conf".source = ../../dotfiles/electron-flags.conf;
  };

  services = {
    network-manager-applet.enable = true;
    syncthing.enable = true;
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      style = "compact";
      history_filter = [
        "^cd"
        "^ll"
        "^n?vim"
      ];
      common_prefix = [ "sudo" "ll" "cd" "clear" "ls" "echo" "pwd" "exit" "history" ];
      secrets_filter = true;
      enter_accept = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = unstablePkgs.vscodium;
    extensions = with unstablePkgs.vscode-extensions; [
      mvllow.rose-pine
      vscodevim.vim
      esbenp.prettier-vscode
      svelte.svelte-vscode
      rust-lang.rust-analyzer
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Mostly for use with comma
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs.nix-index;
  };

  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };
}

