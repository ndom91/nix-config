{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vivaldi
    gnome.gnome-boxes
    slack
    virt-manager
    lazygit
    wezterm

    zathura
    vlc
    whois
    jq

    starship

    (nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
    noto-fonts-color-emoji

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
