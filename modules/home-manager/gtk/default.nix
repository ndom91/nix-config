{ pkgs, lib, osConfig, rose-pine-cursor, config, ... }:
let
  colloidIconTheme = pkgs.colloid-icon-theme.override {
    schemeVariants = [ "nord" ];
    colorVariants = [ "grey" ];
  };

  catppuccin_name = "catppuccin-mocha-maroon-standard+normal";
  catppuccin = pkgs.catppuccin-gtk.override {
    accents = [ "maroon" ];
    size = "standard";
    tweaks = [ "normal" ];
    variant = "mocha";
  };
in
{
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

    theme = {
      name = catppuccin_name;
      package = catppuccin;
    };

    cursorTheme = {
      package = rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = lib.mkMerge [
        (lib.mkIf (osConfig.networking.hostName == "ndo4") 24)
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
        "file:///opt/ndomino ndomino"
        "file:///opt/gitbutler gitbutler"
        "file:///opt/nextauthjs authjs"
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

  home.file.".config/gtk-4.0/gtk-dark.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";
  home.file.".config/gtk-4.0/assets" = {
    recursive = true;
    source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/assets";
  };

  # services.xsettingsd = {
  #   enable = true;
  #   settings = {
  #     "Net/ThemeName" = "Catppuccin-Mocha-Standard-Maroon-Dark";
  #     "Net/IconThemeName" = "Dracula";
  #   };
  # };
}
