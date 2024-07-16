{ input, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty-themes
  ];

  programs.kitty = {
    enable = true;
    font = {
      name = "Operator Mono";
      size = 10;
    };
    shellIntegration.enableBashIntegration = true;
    theme = "Catppuccin-Mocha";
    #Also available: Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
    # See all available kitty themes at: https://github.com/kovidgoyal/kitty-themes/blob/46d9dfe230f315a6a0c62f4687f6b3da20fd05e4/themes.json
  };
}
