{ pkgs, lib, osConfig, rose-pine-cursor, config, ... }:
let
  colloidIconTheme = pkgs.colloid-icon-theme.override {
    schemeVariants = [ "nord" ];
    colorVariants = [ "grey" ];
  };
in
{
  imports = [
    ./catppuccin.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = lib.mkMerge [
      (lib.mkIf (osConfig.networking.hostName == "ndo4") 24)
      (lib.mkIf (osConfig.networking.hostName == "ndo2") 32)
    ];
  };

  gtk = {
    enable = true;
    font.name = "SFProDisplay Nerd Font";

    cursorTheme = {
      package = rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = lib.mkMerge [
        (lib.mkIf (osConfig.networking.hostName == "ndo4") 24)
        (lib.mkIf (osConfig.networking.hostName == "ndo2") 32)
      ];
    };

    iconTheme = {
      package = colloidIconTheme;
      name = "Colloid-grey-nord-dark";
    };

    gtk2.extraConfig = ''
      "gtk-application-prefer-dark-theme = 1"
    '';

    gtk3 = {
      bookmarks = [
        "file:///home/ndo/Downloads Downloads"
        "file:///home/ndo/Pictures Pictures"
        "file:///home/ndo/Documents Documents"
        "file:///home/ndo/Videos Videos"
        "file:///opt/nextauthjs authjs"
        "file:///opt/ndomino ndomino"
        "file:///opt opt"
        "file:///mnt mnt"
      ];
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # services.xsettingsd = {
  #   enable = true;
  #   settings = {
  #     "Net/ThemeName" = "Catppuccin-Mocha-Standard-Maroon-Dark";
  #     "Net/IconThemeName" = "Dracula";
  #   };
  # };
}
