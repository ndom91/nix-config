{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, stateVersion, config, pkgs, unstablePkgs, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    # User Packages
    ../../modules/home-manager/user-packages.nix
    # Programming Lanaguages
    ../../modules/home-manager/languages/rust.nix
    # Common
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/bash.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/ghostty.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/neofetch.nix
    ../../modules/home-manager/neovim.nix
    # ../../modules/home-manager/nixcord.nix
    ../../modules/home-manager/scripts
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/wayland
    ../../modules/home-manager/wezterm.nix
    ../../modules/home-manager/xdg.nix
    ../../modules/home-manager/zathura.nix
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
    ".config/chrome-flags.conf".source = ../../dotfiles/chrome-flags.conf;
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

  programs.lazygit = {
    enable = true;
    package = unstablePkgs.lazygit;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          # externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
        };
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = unstablePkgs.vscodium;
    extensions = with unstablePkgs.vscode-extensions; [
      # Theme
      mvllow.rose-pine
      # General
      asvetliakov.vscode-neovim
      # vscodevim.vim
      github.copilot
      eamodio.gitlens
      # Languages
      esbenp.prettier-vscode
      # rust-lang.rust-analyzer
      svelte.svelte-vscode
    ];
    userSettings = {
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.verticalScrollbarSize" = 0;
      "security.workspace.trust.untrustedFiles" = "newWindow";
      "security.workspace.trust.startupPrompt" = "never";
      "security.workspace.trust.enabled" = false;
      "editor.fontFamily" = "'Operator Mono', 'monospace', monospace";
      "extensions.autoUpdate" = false;
      "terminal.external.linuxExec" = "kitty";
      "telemetry.telemetryLevel" = "off";
      "window.menuBarVisibility" = "toggle";
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "svelte.enable-ts-plugin" = true;
      "[svelte]" = {
        "editor.defaultFormatter" = "svelte.svelte-vscode";
      };
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.fontWeight" = "300";
      "editor.fontSize" = 13;
      "vim.smartRelativeLine" = true;
      "workbench.iconTheme" = "rose-pine-icons";
      "workbench.colorTheme" = "Rosé Pine";
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "vscode-neovim.neovimClean" = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  home.sessionVariables = {
    "_ZO_DOCTOR" = "0";
  };
}
