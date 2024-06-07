{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
  ];

  qt = {
    enable = true;
    platformTheme = {
      name = "gtk3";
    };
    style = {
      name = "adwaita-dark";
      # package = pkgs.qt6Packages.qt6gtk2;
    };
  };
}
