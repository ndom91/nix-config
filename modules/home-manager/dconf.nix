{
  dconf.settings = {
    "org/gnome/TextEditor" = {
      style-variant = "dark";
      style-scheme = "classic-dark";
      show-line-numbers = true;
      show-map = true;
      highlight-current-line = true;
      use-system-font = true;
      indent-style = "space";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      default-sort-order = "date_modified";
      date-time-format = "detailed";
      always-use-location-entry = true;
      show-delete-permanently = true;
      show-hidden-files = true;
    };

    "org/freedesktop/appearance" = {
      color-scheme = 1;
    };

    "org/nemo/preferences" = {
      date-format = "iso";
      default-folder-viewer = "list-view";
      default-sort-in-reverse-order = true;
      default-sort-order = "mtime";
      inherit-folder-viewer = true;
      show-full-path-titles = true;
      show-hidden-files = true;
      show-new-folder-icon-toolbar = true;
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "system/locale" = {
      region = "en_US.UTF-8";
    };
  };
}
