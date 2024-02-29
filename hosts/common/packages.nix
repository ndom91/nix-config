{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Graphical Applications
    vivaldi
    gnome.gnome-boxes
    gnome.seahorse
    slack
    virt-manager
    wezterm
    gnome-text-editor
    cinnamon.nemo
    vlc

    # System Tools
    qdirstat
    gparted
    libsecret

    # Terminal Apps
    lazygit
    lazydocker
    starship
    whois
    jq
    cliphist


    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
    noto-fonts-color-emoji

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
