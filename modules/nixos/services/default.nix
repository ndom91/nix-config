{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ../home-manager/modules/home-manager/thunar.nix
  ];
}
