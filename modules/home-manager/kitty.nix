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
    shellIntegration = {
      enableBashIntegration = true;
      mode = "no-cursor";
    };
    settings = {
      font_size = 10;
      font_family = "Operator Mono Light";
      bold_font = "Operator Mono Medium";
      italic_font = "Operator Mono Book Italic";
      bold_italic_font = "Operator Mono Medium Italic";

      cursor_shape = "block";
      copy_on_select = "clipboard";
      enable_audio_bell = false;
      background_opacity = "0.7";
    };
    theme = "Rosé Pine";
  };
}
