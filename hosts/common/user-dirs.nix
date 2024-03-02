{ pkgs, ... }:
{
  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/dotfiles";
      XDG_MISC_DIR = "${config.home.homeDirectory}/dotfiles";
    };
  };
}
