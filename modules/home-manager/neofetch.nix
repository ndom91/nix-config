{ lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    neofetch
  ];

  xdg.configFile."neofetch/config.conf" = {
    force = true;
    source = ../../dotfiles/neofetch.conf;
  };
}
