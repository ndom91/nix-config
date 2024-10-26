{ inputs, pkgs, unstablePkgs, ... }:
{
  # kickstart-nix.nvim: https://github.com/mrcjkb/kickstart-nix.nvim
  # Example with LSP installs via nix: https://github.com/ryan4yin/nix-config/blob/main/home/base/desktop/editors/neovim/astronvim_user/init.lua
  # https://github.com/b-src/lazy-nix-helper.nvim
  # https://github.com/mrjones2014/dotfiles/blob/master/home-manager/modules/nvim.nix

  xdg.configFile."nvim/" = {
    source = ../../dotfiles/nvim;
    recursive = true;
  };

  programs.neovim.catppuccin.enable = false;
  # https://github.com/BirdeeHub/nixCats-nvim
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.x86_64-linux.neovim;

    viAlias = true;
    vimAlias = true;

    # plugins = [ ];
    # extraConfig = ''
    # '';
    extraLuaConfig = ''
      vim.opt.runtimpath = vim.opt.runtimepath + "${unstablePkgs.vimPlugins.nvim-treesitter.withAllGrammars}"
    '';
    extraPython3Packages = ps: [
      ps.libtmux
      ps.pynvim
    ];
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      # prettierd
      eslint_d
      unstablePkgs.rustywind

      shellcheck
      unstablePkgs.vscode-langservers-extracted # eslint, css, html, json, markdown
      unstablePkgs.shfmt
      unstablePkgs.charm-freeze # code screenshots
      unstablePkgs.stylua
      unstablePkgs.lua-language-server
      unstablePkgs.nodePackages_latest.typescript-language-server

      vimPlugins.telescope-fzf-native-nvim
      unstablePkgs.vimPlugins.nvim-treesitter.withAllGrammars

      # # for compiling Treesitter parsers
      # gcc
      #
      # # debuggers
      # lldb # comes with lldb-vscode
      #
      # # formatters and linters
      # nixfmt
      # rustfmt
      # shfmt
      # cbfmt
      # stylua
      # codespell
      # statix
      # luajitPackages.luacheck
      # prettierd
      #
      # # LSP servers
      # efm-langserver
      # nil
      # rust-analyzer
      # taplo
      # gopls
      # lua
      # shellcheck
      # marksman
      # sumneko-lua-language-server
      # nodePackages_latest.typescript-language-server
      # yaml-language-server
      #
      # # this includes css-lsp, html-lsp, json-lsp, eslint-lsp
      # nodePackages_latest.vscode-langservers-extracted

    ];
  };
}
