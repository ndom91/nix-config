{ pkgs, inputs, unstablePkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # bottles # wine manager
    # zig
    inputs.agenix.packages.x86_64-linux.default # Agenix secret manager
    nvtopPackages.amd # AMD GPU Top
    amdgpu_top # AMD GPU Top
    # appimagekit # AppImageKit
    appimage-run # AppImage Runner
    bat # cat replacement
    # bluez
    brightnessctl # Brightness Control
    cmake # CMake
    coreutils # GNU Core Utilities
    dconf # DConf Editor
    dig # DNS Lookup
    difftastic # diff tool
    docker-compose # Docker Compose
    dua # Disk Usage Analyzer
    dumb-init # pid1 init system for Docker
    eza # ls replacement (Rust)
    fd # find replacement (Rust)
    ffmpeg # multimedia framework
    file # File type identification
    fzf # Fuzzy Finder
    gcc # GNU Compiler Collection
    git # Git
    gnome-disk-utility # Disks Utility (GParted)
    gnumake # gmake (GNU Make)
    gnupg # GPG
    htop # system process monitor
    inotify-tools # inotifywait
    ipmitool # IPMI Tool
    jq # CLI JSON Client
    killall # killall
    keyutils # Tools to manage linux kernel key management
    kmon # Linux Kernel Monitor
    libcamera # libcamera
    # libfprint-2-tod1-elan
    libnotify # libnotify
    unstablePkgs.lla # ls rust replacement
    lm_sensors # sensors
    lshw # Hardware List
    lsof # List Open Files
    mlocate # Safer 'locate'
    nmap # Network Mapper
    ntfs3g # Mount NTFS drives
    ntp # Network Time Protocol client
    ouch # Compress / decompress many formats
    pamixer # PulseAudio Mixer
    pasystray # PulseAudio Sys Tray app
    pavucontrol # PulseAudio Volume Control
    pciutils # lspci
    powertop # Power TOP displays power consumption
    python312Packages.requests # Python Requests
    qemu # QEMU
    rclone # cloud storage client
    ripgrep # rg
    openssh # SSH 
    sshfs # SSH Filesystem
    smartmontools # S.M.A.R.T. monitoring
    system-config-printer # printer configuration
    tmux # Terminal Multiplexer
    tracexec # Trace exec system calls
    traceroute # Network Traceroute
    tree # List directories recursively
    unzip # Unzip files
    usbutils # Provides lsusb
    watch # Command line tool to execute a program periodically
    wget # Web Downloader
    xdg-user-dirs
    libva-utils # vainfo
    vdpauinfo # VDPAU (Video Decode and Presentation API for Unix)
    via # QMK Keyboard Config Tool
    vulkan-tools # vulkaninfo
    # way-displays # Manage Wayland Displays
    # unstablePkgs.webkitgtk_4_0 # WebKitGTK 4.0 (Tauri v1)
    unstablePkgs.webkitgtk_4_1 # WebKitGTK 4.1 (Tauri v2)
    wlay # GUI Wayland Output Management
    wireguard-tools # wg-quick
    zip
    # zoxide # cd replacement

    # bibata-cursors-translucent
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop

    zsa-udev-rules # Voyager Oryx
    keymapp # ZSA Flasher Util

    # Theme
    (colloid-icon-theme.override {
      schemeVariants = [ "nord" ];
      colorVariants = [ "grey" ];
    })
  ];

  services.udev.packages = with pkgs; [
    via
  ];
}

