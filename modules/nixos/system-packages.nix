{ pkgs, inputs, unstablePkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # bottles # wine manager
    # zig
    inputs.agenix.packages.x86_64-linux.default
    amdgpu_top
    nvtop-amd
    appimage-run
    bat
    bluez
    brightnessctl
    catppuccin-gtk
    cmake
    coreutils
    dconf
    dig
    difftastic
    docker-compose
    dua
    dumb-init
    eza
    fd
    ffmpeg
    file
    fzf
    gcc
    git
    gnome.gnome-disk-utility
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
    unstablePkgs.mesa
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
    openssh
    sshfs
    smartmontools
    system-config-printer
    tailspin
    tmux
    tree
    tree
    unzip
    usbutils
    watch
    wget
    xdg-user-dirs
    libva-utils
    vdpauinfo
    vulkan-tools
    zip
    zoxide

    # sddm
    # bibata-cursors-translucent
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop

    # Fonts
    (unstablePkgs.nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" "JetBrainsMono" "FiraCode" "FiraMono" "GeistMono" "Hack" "Ubuntu" "UbuntuMono" ]; })
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd
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

