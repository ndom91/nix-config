{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.ndom91.thunar;
in
{
  options.ndom91 = {
    thunar.enable = lib.mkEnableOption "Enable Thunar XFCE File Manager";
  };

  config = lib.mkIf cfg.enable {
    programs.xfconf.enable = true;
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];

    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}
