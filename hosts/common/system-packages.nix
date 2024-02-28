{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    brightnessctl
    coreutils
    dconf
    difftastic
    docker-compose
    dua
    eza
    fd
    ffmpeg
    file
    fzf
    gcc
    git
    gnumake
    gnupg
    cmake
    htop
    ipmitool
    imv
    jq
    libnotify
    lm_sensors
    lshw
    neofetch
    nmap
    ouch
    pasystray
    pavucontrol
    polkit_gnome
    qemu
    ripgrep
    smartmontools
    tmux
    tree
    tree
    unzip
    watch
    wget
    zip
    # zig
    zoxide

    # sddm
    bibata-cursors
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop
    sddm-chili-theme
  ];
}
}
}
