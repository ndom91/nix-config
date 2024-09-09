{ inputs, config, unstablePkgs, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Graphical Applications
    unstablePkgs.xpipe
    unstablePkgs.zed-editor
    github-desktop

    # Chromium
    (unstablePkgs.vivaldi.override {
      # isSnapshot = true;
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        #   "--ozone-platform=wayland"
        #   "--enable-features=VaapiVideoDecoder"
        #   "--use-gl=egl"
        #
        #   "--use-gl=angle"
        #   "--use-angle=gl"
        #   "--ignore-gpu-blacklist"
        #   "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,RawDraw,CanvasOopRasterization"
        #   "--enable-gpu-rasterization"
        #   "--enable-zero-copy"
        #   "--enable-hardware-overlays"
        #   "--enable-native-gpu-memory-buffers"
        #   "--enable-webrtc-pipewire-capturer"
      ];
    })

    # Experimental
    unstablePkgs.flameshot
    unstablePkgs.zed-editor

    unstablePkgs.chromium # Browser
    floorp # Firefox
    gnome.gnome-boxes # VM Manager
    gnome.seahorse # GPG Key Manager
    slack # Chat
    unstablePkgs.vesktop # Discord fork
    virt-manager # VM Manager
    gnome-text-editor # Plain Text Editor
    cinnamon.nemo # GUI File Manager
    gnome.file-roller # GUI Archive Manager
    vlc # Media Player
    loupe # Image Viewer

    # Build currently broken - https://github.com/NixOS/nixpkgs/issues/328884
    # rustdesk # Remote Desktop
    obsidian # Note Taking

    # System Tools
    qdirstat # Disk Usage Analyzer
    gparted # Partition Manager
    libsecret # Secret Service
    polkit_gnome # Polkit Agent
    unstablePkgs.rclone # cloud storage client

    # Dev Tools
    beekeeper-studio # SQL Client
    sqlite # Database
    mitmproxy # Proxy
    # prettier-d-slim # Prettier Daemon
    # unstablePkgs.nodePackages.wrangler
    (builtins.getFlake "github:NixOS/nixpkgs/8dfad603247387df1df4826b8bea58efc5d012d8").legacyPackages.${pkgs.system}.nodePackages.wrangler
    unstablePkgs.tree-sitter
    unstablePkgs.toolong # CLI to tail log files
    unstablePkgs.tailspin # Log file highlighter

    # Nix Tools
    nvd # Nix Visual Diff
    comma # Run commands in a nix-shell with comma prefix

    # Hardware Tools
    btop # system process monitor
    bottom # not top
    procs # process viewer
    bandwhich # network monitor
    hyperfine # command-line benchmarking tool
    gping # ping, but with a graph(TUI)
    doggo # DNS client for humans
    duf # Disk Usage/Free Utility - a better 'df' alternative
    ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)
    gpu-viewer # GPU htop
    via # QMK Keyboard Config Tool

    # Terminal Apps
    unstablePkgs.charm-freeze # Code Screenshots
    lazygit # TUI Git Client
    lazydocker # TUI Docker
    starship # Terminal Prompt
    hwatch # Interactive 'watch' alternative
    whois
    jq # CLI JSON Client
    cliphist # Clipboard History
    irssi # IRC Client
    parted # GParted Terminal
    ranger # TUI File Manager
    kondo # Multi-language vendor file cleaner (node_modules, vendor, etc)
    speedtest-rs # Speedtest CLI
    unstablePkgs.yazi # Terminal File Manager
    unstablePkgs.netscanner # TUI Subnet Scanner
    unstablePkgs.termscp # TUI S3/SFTP/etc client
    unstablePkgs.oha # HTML Load Tester
    inputs.superfile.packages.${system}.default # TUI File Manager
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];
}
