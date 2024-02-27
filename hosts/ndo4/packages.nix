{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.vivaldi
    pkgs.gnome.gnome-boxes
    pkgs.slack
    pkgs.virt-manager
    pkgs.lazygit
    pkgs.alejandra
    pkgs.wezterm

    (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
    pkgs.noto-fonts-color-emoji
    pkgs.starship

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
