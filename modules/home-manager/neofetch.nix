{ lib, input, pkgs, ... }:
{

  home.packages = with pkgs; [
    neofetch
  ];

  xdg.configFile."neofetch/config.conf" = {
    source = ../../dotfiles/neofetch.conf;
  };
}
