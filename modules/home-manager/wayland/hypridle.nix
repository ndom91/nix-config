{ pkgs, config, inputs, lib, ... }:
{
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          # lock_cmd = "pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          # lock_cmd = lib.getExe config.programs.hyprlock.package;
          # avoid starting multiple hyprlock instances.
          lock_cmd = "pidof ${config.programs.hyprlock.package}/bin/hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";

          # lock before suspend.
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";

          # to avoid having to press a key twice to turn on the display.
          after_sleep_cmd = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          inhibit_sleep = 3;
        };
        listener = [
          {
            # 5m - dim screen
            timeout = 300;
            on-timeout = "brightnessctl -s set 30"; # set monitor backlight to minimum.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          {
            # 9m50s - alert user about incoming lock
            timeout = 590;
            on-timeout = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 10000";
          }
          {
            # 10m - lock the screen
            timeout = 600;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            # 11m - turn off the screen
            timeout = 660;
            on-timeout = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            # 1hr - suspend-then-hibernate
            timeout = 3600;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
          }
        ];
      };
    };
  };
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
