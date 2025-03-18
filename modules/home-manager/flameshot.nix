{ pkgs, lib, ... }:
{
  # Flameshot is a great screenshot + annotation tool, unfortunately it doens't run
  # natively under Wayland yet, but it does seem to play nicely with xwayland + hyprland :pray:

  home.packages = with pkgs; [
    (flameshot.override {
      # Enable USE_WAYLAND_GRIM compile flag
      enableWlrSupport = true;
    })
  ];

  xdg.configFile."flameshot/flameshot.ini" = {
    force = true;
    text = ''
      [General]
      buttons=@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\x16\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\x6\0\0\0\x12\0\0\0\xf\0\0\0\x13\0\0\0\b\0\0\0\t\0\0\0\x10\0\0\0\n\0\0\0\v\0\0\0\r\0\0\0\x17\0\0\0\xe\0\0\0\f\0\0\0\x11\0\0\0\x14\0\0\0\x15)
      contrastOpacity=188
      disabledTrayIcon=true
      saveLastRegion=true
      savePath=/home/ndo/Pictures/Screenshots
      showStartupLaunchMessage=false
    '';
  };
}
