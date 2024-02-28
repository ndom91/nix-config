{ inputs, config, pkgs, ... }:
{

  imports = with pkgs inputs; [
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
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/waybar/default.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/rofi/default.nix
  ];
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.pointerCursor = {
    gtk.enable = true;
    # package = pkgs.bibata-cursors;
    # name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors-translucent;
    name = "Bibata Ghost";
    size = 16;
  };

  # colorScheme = nix-colors.colorSchemes.rose-pine;

  home.file = {
    "./.config/nvim/" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
    "./.ripgreprc".source = ../../dotfiles/.ripgreprc;
    "./.config/starship.toml".source = ../../dotfiles/starship.toml;
    "/run/current-system/sw/share/sddm/faces/ndo.face.icon".source = ../../dotfiles/.face.icon;
    "./.config/hypr/wallpapers/dark-purple-space-01.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    HYPRLAND_LOG_WLR = "1";
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

