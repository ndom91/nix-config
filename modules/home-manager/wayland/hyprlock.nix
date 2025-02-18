{ config, unstablePkgs, pkgs, ... }:
let
  font_family = "Fira Sans Light";
in
{
  programs.hyprlock = {
    enable = true;
    package = unstablePkgs.hyprlock;
    settings = {
      general = {
        disable_loading_bar = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
          blur_size = 5;
          brightness = 0.5;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          position = "0, -60";
          dots_center = true;
          fade_on_empty = true;
          fade_timeout = 5000;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          rounding = 15;
          placeholder_text = ''<span font_family="${font_family}" foreground='##cad3f5'>Password...</span>'';
          fail_color = "rgb(204, 34, 34)";
          fail_text = "$FAIL <b>($ATTEMPTS)</b>";
          fail_transition = 500;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          inherit font_family;
          font_size = 50;
          position = "0, 150";
          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +'%A %B %d'";
          inherit font_family;
          font_size = 20;
          position = "0, 50";
          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
