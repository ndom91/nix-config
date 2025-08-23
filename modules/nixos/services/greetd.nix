{ lib, inputs, config, pkgs, ... }: {
  # let
  #   tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  #   hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
  # in
  # {
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = ''
  #         ${tuigreet} \
  #           --asterisks \
  #           --time \
  #           --time-format '%I:%M %p • %a %h %d | %F' \
  #           --remember \
  #           --remember-session \
  #           --power-shutdown /run/current-system/systemd/bin/systemctl poweroff \
  #           --power-reboot /run/current-system/systemd/bin/systemctl reboot \
  #           --sessions ${hyprland-session}
  #       '';
  #       user = "greeter";
  #     };
  #   };
  # };
  services.greetd =
    let
      session = {
        # command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --remember \
          --asterisks \
          --sessions "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions" \
          --cmd "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop"
        '';
        user = "ndo";
      };
    in
    {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        # Autologin
        # initial_session = session;
      };
    };

  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal"; # Without this errors will spam on screen
  #   # Without these bootlogs will spam on screen
  #   TTYReset = true;
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };
}
