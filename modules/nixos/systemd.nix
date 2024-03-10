{ pkgs, ... }:
{
  # TODO - not enabled anywhere yet
  systemd.services.toplevel-override = {
    description = "systemd toplevel onfailure override";
    serviceConfig = {
      OnFailure = "failure-notification@%n";
    };
  };
  systemd.services."failure-notification@" = {
    after = [ "graphical-session.target" "network.target" ];
    description = "failure-notification";
    serviceConfig = {
      Type = "simple";
      # username that systemd will look for; if it exists, it will start a service associated with that user
      User = "ndo";
      ExecStart = "/etc/nixos/dotfiles/failure-notification.sh %i";
    };
  };
}
