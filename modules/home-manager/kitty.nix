{ unstablePkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = unstablePkgs.kitty;
    # Pick "name" from https://github.com/kovidgoyal/kitty-themes/blob/master/themes.json
    theme = "Rosé Pine";
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
      shell = "${pkgs.tmux}/bin/tmux";
      confirm_os_window_close = 0;
    };
  };
}
