{ input, pkgs, ... }:
{
  # environment.systemPackages = with pkgs; [
  #   kitty-themes
  # ];

  programs.kitty = {
    enable = true;
    # font = {
    #   name = "Operator Mono Light";
    #   size = 10;
    # };
    settings = {
      shell_integration = "no-cursor";

      font_size = 10;
      font_family = "Operator Mono Light";
      bold_font = "Operator Mono Medium";
      italic_font = "Operator Mono Book Italic";
      bold_italic_font = "Operator Mono Medium Italic";

      cursor_shape = "block";
      copy_on_select = "clipboard";
      enable_audio_bell = false;
      background_opacity = "0.8";
    };
    shellIntegration.enableBashIntegration = true;
    theme = "Catppuccin-Mocha";
    #Also available: Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
    # See all available kitty themes at: https://github.com/kovidgoyal/kitty-themes/blob/46d9dfe230f315a6a0c62f4687f6b3da20fd05e4/themes.json
  };
}
