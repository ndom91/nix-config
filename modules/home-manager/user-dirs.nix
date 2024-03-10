{ config, pkgs, ... }:
{
  xdg.configFile."user-dirs.dirs".force = true;
  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/dotfiles";
      XDG_MISC_DIR = "${config.home.homeDirectory}/dotfiles";
    };
  };

  home.file = {
    ".config/gtk-3.0/bookmarks".text = ''
      file:///home/ndo/Downloads Downloads
      file:///home/ndo/Pictures Pictures
      file:///home/ndo/Documents Documents
      file:///home/ndo/Videos Videos
      file:///opt/nextauthjs authjs
      file:///opt opt
      file:///mnt mnt
    '';
  };
}
