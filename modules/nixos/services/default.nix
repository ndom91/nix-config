{ config
, lib
, pkgs
, ...
}:

{


  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=100M
    SystemMaxFiles=5
    MaxRetentionSec=1month
  '';

  imports = [
    ../../home-manager/thunar.nix
  ];
}
