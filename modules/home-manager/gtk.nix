{ pkgs
, config
, ...
}:
{
  # home.file = {
  #   ".local/share/icons/GruvboxPlus".source = "${gruvboxPlus}";
  # };

  gtk.enable = true;

  gtk.theme.package = pkgs.catppuccin-gtk;
  gtk.theme.name = "Catppuccin-Mocha-Standard-Maroon-Dark";

  # gtk.cursorTheme.package = pkgs.catppuccin-cursors;
  # gtk.cursorTheme.name = "mochaDark";
  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Classic";

  gtk.iconTheme.package = pkgs.dracula-icon-theme;
  gtk.iconTheme.name = "Dracula";

  # xdg.configFile."gtk-4.0/gtk.css" = {
  #   text = cssContent;
  # };
  #
  # xdg.configFile."gtk-3.0/gtk.css" = {
  #   text = cssContent;
  # };
}
