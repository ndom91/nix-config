{ pkgs, ... }: {
  # See: https://wiki.archlinux.org/title/Plymouth#Smooth_transition
  systemd.user.services.display-manager = {
    overrideStrategy = "asDropin";
    conflicts = [ "plymouth-quit.service" ];
    after = [
      "plymouth-quit.service"
      "rc-local.service"
      "plymouth-start.service"
      "systemd-user-sessions.service"
    ];
    onFailure = [ "plymouth-quit.service" ];

    serviceConfig = {
      ExecStartPost = "sleep 30";
      ExecStartPost = "${pkgs.plymouth}/bin/plymouth quit --retain-splash";
    };
  };
}
