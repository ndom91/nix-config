{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, config, pkgs, unstablePkgs, ... }:
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
    ../../modules/home-manager/user-dirs.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/mimeApps.nix
    ../../modules/home-manager/gtk/default.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/wayland/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = "23.11";
  home.packages = [
    inputs.home-manager.packages.x86_64-linux.home-manager # home-manager binary
    fira-sans-nerd-font
  ];

  systemd.user.sessionVariables = config.home.sessionVariables;

  # Themes - https://github.com/tinted-theming/base16-schemes
  colorScheme = nix-colors.colorSchemes.rose-pine;

  dconf.settings = {
    "org/gnome/TextEditor" = {
      style-variant = "dark";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/freedesktop/appearance" = {
      color-scheme = 1;
    };

    "org/nemo/preferences" = {
      date-format = "iso";
      default-folder-viewer = "list-view";
      default-sort-in-reverse-order = true;
      default-sort-order = "mtime";
      inherit-folder-viewer = true;
      show-full-path-titles = true;
      show-hidden-files = true;
      show-new-folder-icon-toolbar = true;
    };
  };

  # ndo2 overrides
  wayland.windowManager.hyprland = {
    settings = {
      # monitor = lib.mkForce "eDP-1,preferred,auto,1.333333";
      monitor = lib.mkForce "eDP-1,preferred,auto,1.333333";
      env = lib.mkForce [
        "GDK_SCALE,1.5"
      ];
      exec-once = [
        "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1.5"
      ];

      # "device:MSFT0001:00 04F3:31EB Touchpad" = {
      #   accel_profile = "adaptive";
      #   natural_scroll = true;
      #   sensitivity = 0.1;
      # };

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

    ".config/hypr/wallpaper.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;

    ".config/brave-flags.conf".source = ../../dotfiles/brave-flags.conf;
    ".config/code-flags.conf".source = ../../dotfiles/code-flags.conf;
    ".config/electron-flags.conf".source = ../../dotfiles/electron-flags.conf;
  };

  fonts.fontconfig.enable = true;

  services = {
    network-manager-applet.enable = true;
    syncthing.enable = true;
  };

  programs.atuin = {
    enable = false;
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

