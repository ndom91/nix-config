{ input, pkgs, ... }:
{
  # kickstart-nix.nvim: https://github.com/mrcjkb/kickstart-nix.nvim
  # Example with LSP installs via nix: https://github.com/ryan4yin/nix-config/blob/main/home/base/desktop/editors/neovim/astronvim_user/init.lua
  # https://github.com/b-src/lazy-nix-helper.nvim
  # https://github.com/mrjones2014/dotfiles/blob/master/home-manager/modules/nvim.nix
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # plugins = [ ];
    extraConfig = ''
    '';
    extraLuaConfig = ''
      vim.opt.runtimpath = vim.opt.runtimepath + "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}"
    '';
    extraPython3Packages = with pkgs.python311Packages; [
      libtmux
      pynvim
    ];
    extraPackages = with pkgs; [
      shfmt
      eslint_d
      stylua
      lua-language-server
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars

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
