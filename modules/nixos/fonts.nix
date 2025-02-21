{ inputs, unstablePkgs, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # (unstablePkgs.nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" "JetBrainsMono" "FiraCode" "FiraMono" "GeistMono" "Hack" "Ubuntu" "UbuntuMono" ]; })

      # Sans Serif
      unstablePkgs.fira
      source-serif
      noto-fonts
      noto-fonts-color-emoji
      roboto
      (google-fonts.override { fonts = [ "Inter" ]; })

      # nerdfonts
      # (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = [
          "Source Serif"
          "Noto Serif"
        ];
        sansSerif = [
          "Fira Sans"
          "Noto Sans"
        ];
        monospace = [
          "Operator Mono Book"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };
}
