{ config, pkgs, ... }:
{
  xdg.configFile."user-dirs.dirs".force = true;
  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/dotfiles";
      XDG_MISC_DIR = "${config.home.homeDirectory}/dotfiles";
    };
  };
}
