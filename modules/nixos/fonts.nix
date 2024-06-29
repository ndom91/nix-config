{ inputs, unstablePkgs, pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;

    packages = [
      # (unstablePkgs.nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" "JetBrainsMono" "FiraCode" "FiraMono" "GeistMono" "Hack" "Ubuntu" "UbuntuMono" ]; })

      # Sans(Serif) fonts
      fira
      noto-fonts
      noto-fonts-color-emoji
      roboto
      (google-fonts.override { fonts = [ "Inter" ]; })

      # monospace fonts
      # jetbrains-mono

      # nerdfonts
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [
        "Fira Sans"
        "sans-serif"
      ];
      monospace = [
        "Operator Mono Light"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
  };
}
