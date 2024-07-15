{ pkgs, ... }:
let
  # tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = "${tuigreet} --time --remember --cmd Hyprland";
        command = "Hyprland";
        user = "ndo";
      };
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/home/ndo/.config/greetd/wallpaper.png";
        fit = "Cover";
      };
      GTK = {
        cursor_theme_name = "BreezeX-RosePine-Linux";
        font_name = "Fira Sans";
        icon_theme_name = "Colloid-grey-nord-dark";
        theme_name = "catppuccin-mocha-maroon-standard+normal";
      };
    };
    cageArgs = [ "-s" "-m" "last" ];
  };

  # security.pam.services.greetd.enableGnomeKeyring = true;

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  #environment.etc."greetd/environments".text = ''
  #  Hyprland
  #  fish
  #  bash
  #'';
}
