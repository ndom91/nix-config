{ config, unstablePkgs, pkgs, ... }:
let
  font_family = "Fira Sans Light";
in
{
  programs.hyprlock = {
    enable = true;
    # package = hyprlock;
    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
      };

      # Oddly it only works if this is disabled :thinking:
      # auth = {
      #   fingerprint.enabled = true;
      # };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
          blur_size = 5;
          brightness = 0.5;
        }
      ];
    };
  };
}
