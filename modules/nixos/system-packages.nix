{ pkgs, unstablePkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # bottles # wine manager
    # zig
    alacritty
    appimage-run
    bat
    bluez
    brightnessctl
    catppuccin-gtk
    cmake
    coreutils
    dconf
    difftastic
    docker-compose
    dracula-icon-theme
    dracula-theme
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
    htop
    imv
    inotify-tools
    ipmitool
    jq
    killall
    libcamera
    libfprint-2-tod1-elan
    libnotify
    lm_sensors
    lshw
    mesa
    neofetch
    nmap
    ntfs3g
    ntp
    ouch
    pamixer
    pasystray
    pavucontrol
    python311Packages.requests
    qemu
    rclone
    ripgrep
    smartmontools
    system-config-printer
    tmux
    tree
    tree
    unzip
    watch
    wget
    xdg-user-dirs
    zip
    zoxide

    # sddm
    # bibata-cursors-translucent
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop

    # Fonts
    (unstablePkgs.nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" "JetBrainsMono" "FiraCode" "FiraMono" "GeistMono" "Hack" "Ubuntu" "UbuntuMono" ]; })
    fira
    noto-fonts-color-emoji
  ];

  # Register AppImages as binary format
  # See: https://nixos.wiki/wiki/Appimage
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}

