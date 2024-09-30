{ pkgs, inputs, unstablePkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # bottles # wine manager
    # zig
    inputs.agenix.packages.x86_64-linux.default
    amdgpu_top
    appimagekit
    nvtopPackages.amd
    appimage-run
    bat
    # bluez
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
    inotify-tools
    ipmitool
    jq
    killall
    libcamera
    # libfprint-2-tod1-elan
    libnotify
    lm_sensors
    lshw
    lsof
    mlocate
    nmap
    ntfs3g
    ntp
    ouch
    pamixer
    pasystray
    pavucontrol
    pciutils
    powertop
    python311Packages.requests
    qemu
    rclone
    ripgrep
    openssh
    sshfs
    smartmontools
    system-config-printer
    tmux
    tracexec
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
    way-displays
    wlay
    wireguard-tools
    zip
    zoxide

    # sddm
    # bibata-cursors-translucent
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop

    # Theme
    (colloid-icon-theme.override {
      schemeVariants = [ "nord" ];
      colorVariants = [ "grey" ];
    })
    (catppuccin-gtk.override {
      accents = [ "maroon" ];
      size = "standard";
      tweaks = [ "normal" ];
      variant = "mocha";
    })
  ];

  # Register AppImages as binary format
  # See: https://nixos.wiki/wiki/Appimage
  # boot.binfmt.registrations.appimage = {
  #   wrapInterpreterInShell = false;
  #   interpreter = "${pkgs.appimage-run}/bin/appimage-run";
  #   recognitionType = "magic";
  #   offset = 0;
  #   mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
  #   magicOrExtension = ''\x7fELF....AI\x02'';
  # };
  # Replaced with programs.appimage.binfmt in 24.05
}

