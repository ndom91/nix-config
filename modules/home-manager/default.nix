{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, stateVersion, config, pkgs, unstablePkgs, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    # User Packages
    ../../modules/home-manager/user-packages.nix
    # Programming Lanaguages
    ../../modules/home-manager/languages/rust.nix
    # Common
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/neofetch.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/wayland
    ../../modules/home-manager/scripts
  ];

  home.file = {
    ".ripgreprc".source = ../../dotfiles/.ripgreprc;
    ".local/share/fonts" = {
      recursive = true;
      source = ./../../dotfiles/fonts;
    };

    ".config/hypr/wallpaper.png".source = ../../dotfiles/wallpapers/dark-purple-space-01.png;
    ".config/greetd/wallpaper.png".source = ../../dotfiles/wallpapers/glacier.png;
    ".config/alacritty-rose-pine.toml".source = ../../dotfiles/alacritty-rose-pine.toml;

    ".config/brave-flags.conf".source = ../../dotfiles/brave-flags.conf;
    ".config/electron-flags.conf".source = ../../dotfiles/electron-flags.conf;
  };

  services = {
    syncthing.enable = true;
  };

  programs.bash.enable = true;

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

  programs.vscode = {
    enable = true;
    package = unstablePkgs.vscodium;
    extensions = with unstablePkgs.vscode-extensions; [
      mvllow.rose-pine
      vscodevim.vim
      esbenp.prettier-vscode
      svelte.svelte-vscode
      rust-lang.rust-analyzer
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };
}
