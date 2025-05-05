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
    vscode.enable = false;
    mako.enable = false;
    # waybar.enable = true;
    # nvim.enable = true;
  };

  gtk = {
    enable = true;
    font.name = "Fira Sans";


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
        "file:///opt/nextauthjs authjs"
        "file:///opt opt"
        "file:///mnt mnt"
        "file:///home/ndo/Documents/3d_models 3d_models"
      ];
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        "AdwStyleManager:color-scheme" = "prefer-dark";
        gtk-theme-name = "Adwaita";
      };
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      "AdwStyleManager:color-scheme" = "prefer-dark";
    };
  };

  home.file.".local/share/flatpak/overrides/global".text =
    let
      dirs = [
        "/nix/store:ro"
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
        "${config.xdg.dataHome}/icons:ro"
      ];
    in
    ''
      [Context]
      filesystems=${builtins.concatStringsSep ";" dirs}
    '';

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
