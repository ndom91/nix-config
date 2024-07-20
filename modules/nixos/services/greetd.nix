{ lib, inputs, config, pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";

  username = "user";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${tuigreet} \
            --asterisks \
            --time \
            --time-format '%I:%M %p • %a %h %d | %F' \
            --remember \
            --remember-session \
            --power-shutdown /run/current-system/systemd/bin/systemctl poweroff \
            --power-reboot /run/current-system/systemd/bin/systemctl reboot \
            --sessions ${hyprland-session}
        '';
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
        user = "greeter";
      };
      # default_session = {
      #   user = "ndo";
      #   # See: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/regreet.nix#L66C56-L66C181
      #   command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} -s -- sh -c 'wlr-randr --output DP-1 --mode 3440x1440 && ${lib.getExe config.programs.regreet.package}'";
      # };
    };
  };

  # programs.regreet = {
  #   enable = true;
  #   settings = {
  #     background = {
  #       path = /home/ndo/.config/greetd/wallpaper.png;
  #       fit = "Cover";
  #     };
  #     GTK = {
  #       cursor_theme_name = "BreezeX-RosePine-Linux";
  #       font_name = "Fira Sans";
  #       icon_theme_name = "Colloid-grey-nord-dark";
  #       theme_name = "catppuccin-mocha-maroon-standard+normal";
  #     };
  #   };
  #   cageArgs = [ "-s" ]; # "-m" "last" ];
  # };

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

  # environment.etc."greetd/environments".text = ''
  #  Hyprland
  #  bash
  # '';
}
