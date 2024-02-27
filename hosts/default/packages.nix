{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.vivaldi
    pkgs.gnome.gnome-boxes
    pkgs.slack
    pkgs.virt-manager
    pkgs.lazygit
    pkgs.alejandra

    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    pkgs.noto-fonts-color-emoji
    pkgs.starship

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
