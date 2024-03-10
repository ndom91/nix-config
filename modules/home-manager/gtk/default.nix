{ pkgs, rose-pine-cursor, config, ... }:
{
  imports = [
    ./catppuccin.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 24;
  };

  gtk = {
    enable = true;
    font.name = "FiraSans";

    cursorTheme = {
      package = rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
    };

    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
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

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "Catppuccin-Mocha-Standard-Maroon-Dark";
      "Net/IconThemeName" = "Dracula";
    };
  };
}
