{ lib, inputs, config, pkgs, ... }:
{
  imports = with inputs pkgs; [
    # nix-colors.homeManagerModules.default

    # Common
    ../common/packages.nix
    ../common/gitconfig.nix
    ../common/tmux.nix
    ../common/ssh.nix
    ../common/shell.nix
    ../common/languages/node.nix
    ../common/languages/rust.nix

    # Modules
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/wayland/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = "23.11"; # Please read the comment before changing.

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

  # colorScheme = nix-colors.colorSchemes.rose-pine;

  home.file = {
    "./.config/nvim/" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
    "./.ripgreprc".source = ../../dotfiles/.ripgreprc;
    "./.config/starship.toml".source = ../../dotfiles/starship.toml;
    "/run/current-system/sw/share/sddm/faces/ndo.face.icon".source = ../../dotfiles/.face.icon;
    "./.config/hypr/wallpapers/dark-purple-space-01.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;
    "./.face.icon".source = ../../dotfiles/.face.icon;

    "./.config/waybar/scripts/waybar-wttr.py".source = ../../dotfiles/waybar/scripts/waybar-wttr.py;

    "./.config/vivaldi-stable.conf".source = ../../dotfiles/vivaldi-stable.conf;
    "./.config/brave-flags.conf".source = ../../dotfiles/brave-flags.conf;
    "./.config/code-flags.conf".source = ../../dotfiles/code-flags.conf;
    "./.config/electron-flags.conf".source = ../../dotfiles/electron-flags.conf;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  fonts.fontconfig.enable = true;

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
  programs.zoxide.enable = true;
  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
    };
  };
}
