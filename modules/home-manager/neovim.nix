{ input, pkgs, ... }:
{
  # kickstart-nix.nvim: https://github.com/mrcjkb/kickstart-nix.nvim
  # Example with LSP installs via nix: https://github.com/ryan4yin/nix-config/blob/main/home/base/desktop/editors/neovim/astronvim_user/init.lua
  # https://github.com/b-src/lazy-nix-helper.nvim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # plugins = [ ];
    extraConfig = ''
    '';
    extraLuaConfig = ''
      vim.opt.runtimpath = vim.opt.runtimepath + "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}"
    '';
    extraPackages = with pkgs; [
      shfmt
      eslint_d
      stylua
      lua-language-server
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars

      pkgs.python311Packages.libtmux
      pkgs.python311Packages.pynvim
    ];
  };
}
