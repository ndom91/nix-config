{ inputs, config, pkgs, ... }:
{
  imports = with inputs pkgs; [
    # nix-colors.homeManagerModules.default

    # Common
    ../common/packages.nix
    ../common/gitconfig.nix
    ../common/tmux.nix
    ../common/ssh.nix
    ../common/shell.nix
    ../common/languages/node.nix
    ../common/languages/rust.nix

    # Modules
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/wayland/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # colorScheme = nix-colors.colorSchemes.rose-pine;

  home.file = {
    "./.config/nvim/" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
    "./.ripgreprc".source = ../../dotfiles/.ripgreprc;
    "./.config/starship.toml".source = ../../dotfiles/starship.toml;
    "./.face.icon".source = ../../dotfiles/.face.icon;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };


  programs.atuin = {
    enable = false;
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
  programs.starship.enable = true;
  programs.gh.enable = true;
  programs.git.diff-so-fancy.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zoxide.enable = true;
}
