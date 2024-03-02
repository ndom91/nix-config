{ lib, inputs, config, pkgs, ... }:
{
  imports = with pkgs inputs; [
    # nix-colors.homeManagerModules.default

    # Common
    ../common/packages.nix
    ../common/gitconfig.nix
    ../common/tmux.nix
    ../common/user-dirs.nix
    ../common/ssh.nix
    ../common/sh.nix
    ../common/mimeApps.nix
    ../common/languages/node.nix
    ../common/languages/rust.nix
    # ../common/languages/python.nix

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

  systemd.user.sessionVariables = config.home.sessionVariables;

  # ndo4 overrides
  wayland.windowManager.hyprland = {
    settings = {
      monitor = lib.mkForce [
        "DP-1,3440x1440,1080x480,1"
        "DP-2,1920x1080,0x0,1,transform,3"
      ];
      # monitor = lib.mkForce "eDP-1,highres,auto,1.7";
      env = [
        "GDK_SCALE,1.5"
        "XCURSOR_SIZE,24"
      ];
    };
  };

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

    "./.dotfiles/colorscripts/" = {
      source = ../../dotfiles/colorscripts;
      recursive = true;
    };
  };

  fonts.fontconfig.enable = true;

  services = {
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
          command = "${pkgs.swaylock}/bin/swaylock";
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
          command = "${pkgs.swaylock}/bin/swaylock";
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
  programs.zoxide.enable = true;
  programs.bash.enable = true;
}
