{ lib, pkgs, ... }: {
  xdg.configFile."rofi" = {
    source = ./dotconfig;
    recursive = true;
  };

  # Rofi theme docs: https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown#basic-layout-structure
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "FiraSans Light 12";
    terminal = lib.getExe pkgs.wezterm;
    cycle = true;
  };
}
