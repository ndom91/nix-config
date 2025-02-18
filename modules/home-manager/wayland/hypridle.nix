{ pkgs, config, inputs, lib, ... }:
{
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          # avoid starting multiple hyprlock instances.
          # lock_cmd = "pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          lock_cmd = "pidof ${config.programs.hyprlock.package}/bin/hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          # lock before suspend.
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          # to avoid having to press a key twice to turn on the display.
          after_sleep_cmd = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          inhibit_sleep = 3;
        };
        listener = [
          {
            # Dim screen
            timeout = 300;
            on-timeout = "brightnessctl -s set 20"; # set monitor backlight to minimum.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          {
            # Alert that lock is incoming
            timeout = 590;
            on-timeout = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 10000";
          }
          {
            # Lock the screen
            timeout = 600;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
            # on-timeout = "${config.programs.hyprlock.package}/bin/hyprlock";
          }
          {
            # 60s later, turn off the screen
            timeout = 660;
            on-timeout = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            # At 1hr idle, suspend-then-hibernate
            timeout = 3600;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
          }
        ];
      };
    };
  };
}
