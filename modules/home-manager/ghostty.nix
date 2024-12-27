{ lib, inputs, pkgs, ... }:
{

  home.packages = with pkgs; [
    inputs.ghostty.packages.x86_64-linux.default # Ghostty terminal
  ];

  xdg.configFile."ghostty/config" = {
    force = true;
    source = ../../dotfiles/ghostty.conf;
  };
}
