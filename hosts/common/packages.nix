{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.vivaldi
    pkgs.gnome.gnome-boxes
    pkgs.slack
    pkgs.virt-manager
    pkgs.lazygit
    pkgs.wezterm

    pkgs.zathura
    pkgs.vlc
    pkgs.whois
    pkgs.jq

    pkgs.starship

    (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
    pkgs.noto-fonts-color-emoji

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
