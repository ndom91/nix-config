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
    protonvpn-gui

    # System Tools
    qdirstat
    gparted
    libsecret
    polkit_gnome

    # Dev Tools
    beekeeper-studio
    sqlite
    mitmproxy

    # Hardware Tools
    btop # system process monitor
    bottom # not top
    procs # process viewer
    du-dust # du but rust
    bandwhich # network monitor
    hyperfine # command-line benchmarking tool
    gping # ping, but with a graph(TUI)
    doggo # DNS client for humans
    duf # Disk Usage/Free Utility - a better 'df' alternative
    du-dust # A more intuitive version of `du` in rust
    ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)
    gdu # disk usage analyzer(replacement of `du`)


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
