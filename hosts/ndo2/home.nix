{ inputs, pkgs, ... }:
{
  imports = with inputs pkgs; [
    # nix-colors.homeManagerModules.default

    ../common/packages.nix
    ../common/gitconfig.nix
    ../common/tmux.nix
    ../common/ssh.nix
    ../common/shell.nix

    # Modules
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/waybar.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/rofi/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # colorScheme = nix-colors.colorSchemes.rose-pine;

  home.file = {
    "nvim/init.lua".source = ../../dotfiles/nvim/init.lua;
  };

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # programs.dconf.enable = true;
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      style = "compact";
      history_filter = [
        "^cd"
        "^ll"
        "^n?vim"
      ];
      common_prefix = [ "sudo" "ll" "cd" "clear" "ls" "echo" "pwd" "exit" "history" ];
      secrets_filter = true;
      enter_accept = true;
    };
  };
  programs.gh.enable = true;
  programs.git.diff-so-fancy.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zoxide.enable = true;
}
