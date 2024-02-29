{ pkgs, config, ... }:
{
  # home.file = {
  #   ".local/share/icons/GruvboxPlus".source = "${gruvboxPlus}";
  # };

  imports = [
    ./catppuccin-gtk-4.0.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors-translucent;
    name = "Bibata Ghost";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha-Standard-Maroon-Dark";
    };

    # gtk.cursorTheme.package = pkgs.catppuccin-cursors;
    # gtk.cursorTheme.name = "mochaDark";
    cursorTheme = {
      package = pkgs.bibata-cursors-translucent;
      name = "Bibata Ghost";
      # package = pkgs.bibata-cursors;
      # name = "Bibata-Modern-Classic";
    };

    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    # xdg.configFile."gtk-4.0/gtk.css" = {
    #   text = cssContent;
    # };
    #
    # xdg.configFile."gtk-3.0/gtk.css" = {
    #   text = cssContent;
    # };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "Catppuccin-Mocha-Standard-Maroon-Dark";
      "Net/IconThemeName" = "Dracula";
    };

  };
}
