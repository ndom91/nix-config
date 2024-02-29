{ config, pkgs, lib, ... }:
{
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe pkgs.polkit_gnome;
      Restart = "on-failure";
      BusName = "org.freedesktop.PolicyKit1.Authority";
    };
  };
}
