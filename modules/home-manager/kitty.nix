{ unstablePkgs, ... }:
{
  # programs.kitty.catppuccin.enable = false;
  programs.kitty = {
    enable = true;
    package = unstablePkgs.kitty;
    # Pick "name" from https://github.com/kovidgoyal/kitty-themes/blob/master/themes.json
    # theme = "Rosé Pine";
    themeFile = "rose-pine";
    shellIntegration = {
      enableBashIntegration = true;
      mode = "no-cursor";
    };
    settings = {
      font_size = 10;
      font_family = "Operator Mono Light";
      bold_font = "Operator Mono Book";
      italic_font = "Operator Mono Light Italic";
      bold_italic_font = "Operator Book Italic";

      cursor_shape = "block";
      background_opacity = "0.5";
      inactive_text_alpha = "0.6";

      scrollback_lines = 10000;
      copy_on_select = "clipboard";
      enable_audio_bell = false;
      shell = "${unstablePkgs.tmux}/bin/tmux";
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      # NerdFont symbols override
      symbol_map U+E0A0-U+E0A3,U+E0C0-U+E0C7 FiraSans Nerd Font
      symbol_map U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26A1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D FiraSans Nerd Font
    '';
  };
}
