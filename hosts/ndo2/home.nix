{ rose-pine-cursor, nix-colors, lib, inputs, config, pkgs, unstablePkgs, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    nix-colors.homeManagerModules.default
    # User Packages
    ../../modules/home-manager/user-packages.nix
    # Programming Lanaguages
    ../../modules/home-manager/languages/node.nix
    ../../modules/home-manager/languages/rust.nix
    # Common
    ../../modules/home-manager/gitconfig.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/user-dirs.nix
    ../../modules/home-manager/ssh.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/mimeApps.nix
    ../../modules/home-manager/gtk/default.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/wayland/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  systemd.user.sessionVariables = config.home.sessionVariables;

  # Themes - https://github.com/tinted-theming/base16-schemes
  colorScheme = nix-colors.colorSchemes.rose-pine;

  # ndo2 overrides
  wayland.windowManager.hyprland = {
    settings = {
      monitor = lib.mkForce "eDP-1,preferred,auto,1.7";
      # monitor = lib.mkForce "eDP-1,highres,auto,1.7";
      env = [
        "GDK_SCALE,1.7"
        "XCURSOR_SIZE,32"
      ];

      "device:MSFT0001:00 04F3:31EB Touchpad" = {
        accel_profile = "adaptive";
        natural_scroll = true;
        sensitivity = 0.1;
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

    ".config/starship.toml".source = ../../dotfiles/starship.toml;
    ".config/hypr/wallpaper.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;

    "/run/current-system/sw/share/sddm/faces/ndo.face.icon".source = ../../dotfiles/.face.icon;
    ".face.icon".source = ../../dotfiles/.face.icon;

    ".config/vivaldi-stable.conf".source = ../../dotfiles/vivaldi-stable.conf;
    ".config/brave-flags.conf".source = ../../dotfiles/brave-flags.conf;
    ".config/code-flags.conf".source = ../../dotfiles/code-flags.conf;
    ".config/electron-flags.conf".source = ../../dotfiles/electron-flags.conf;
  };

  fonts.fontconfig.enable = true;

  services = {
    network-manager-applet.enable = true;
    syncthing = {
      enable = true;
      # extraOptions = [ "--wait" ];
      # tray = {
      #   enable = true;
      # };
    };
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 295;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }
        {
          timeout = 300;
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
        {
          timeout = 360;
          command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
      ];
    };
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
  programs.starship.enable = true;
  programs.gh.enable = true;
  programs.git.diff-so-fancy.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };
}

