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

    ### HARDWARE DIAGNOSTICS ###
    btop # system process monitor
    bottom # not top
    procs # process viewer
    du-dust # du but rust
    bandwhich # network monitor

    # Terminal Apps
    lazygit
    lazydocker
    starship
    whois
    jq
    cliphist


    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
