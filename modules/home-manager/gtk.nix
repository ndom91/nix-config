{ pkgs, unstablePkgs, lib, osConfig, rose-pine-cursor, config, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = lib.mkMerge [
      (lib.mkIf (osConfig.networking.hostName == "ndo-gb") 24)
      (lib.mkIf (osConfig.networking.hostName == "ndo4") 24)
      (lib.mkIf (osConfig.networking.hostName == "ndo2") 32)
    ];
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "maroon";

    # Programs
    waybar.enable = true;
    nvim.enable = true;
  };

  gtk = {
    enable = true;
    font.name = "Fira Sans";

    # catppuccin = {
    #   enable = true;
    #   flavor = "mocha";
    #   accent = "maroon";
    #   gnomeShellTheme = true;
    # };

    # theme = {
    #   name = "rose-pine";
    #   # package = pkgs.catppuccin-gtk;
    # };
    theme = {
      # name = "rose-pine";
      # package = unstablePkgs.rose-pine-gtk-theme;

      name = "Graphite-pink-Dark";
      package = unstablePkgs.graphite-gtk-theme.override {
        themeVariants = [ "default" "pink" ];
        tweaks = [ "rimless" "darker" "normal" ];
      };
    };

    cursorTheme = {
      # package = rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = lib.mkMerge [
        (lib.mkIf (osConfig.networking.hostName == "ndo-gb") 24)
        (lib.mkIf (osConfig.networking.hostName == "ndo4") 24)
        (lib.mkIf (osConfig.networking.hostName == "ndo2") 32)
      ];
    };

    iconTheme = {
      # package = colloidIconTheme;
      name = "Colloid-Grey-Nord-Dark";
      # name = "BreezeX-RosePine-Linux";
      # name = "BreezeX-RosePineDawn-Linux";
      # name = "Colloid-Dark";
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
        "AdwStyleManager:color-scheme" = "prefer-dark";
      };
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      "AdwStyleManager:color-scheme" = "prefer-dark";
    };
  };

  # home.file.".config/gtk-4.0/gtk-dark.css".source = "${pkgs.catppuccin-gtk}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";
  # home.file.".config/gtk-4.0/assets" = {
  #   recursive = true;
  #   source = "${pkgs.catppuccin-gtk}/share/themes/${catppuccin_name}/gtk-4.0/assets";
  # };

  # services.xsettingsd = {
  #   enable = true;
  #   settings = {
  #     "Net/ThemeName" = "Catppuccin-Mocha-Standard-Maroon-Dark";
  #     "Net/IconThemeName" = "Dracula";
  #   };
  # };
}
