{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    appimage-run
    bat
    bluez
    brightnessctl
    catppuccin-gtk
    coreutils
    dconf
    difftastic
    docker-compose
    dracula-theme
    dracula-icon-theme
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
    inotify-tools
    imv
    jq
    libnotify
    libcamera
    lm_sensors
    lshw
    mesa
    neofetch
    nmap
    ouch
    pasystray
    pavucontrol
    pamixer
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
    zip
    # zig
    zoxide

    # sddm
    bibata-cursors-translucent
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop

    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
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

