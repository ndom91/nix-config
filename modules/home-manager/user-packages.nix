{ inputs, config, unstablePkgs, pkgs, pkgs2505, ... }:
{
  home.packages = with pkgs; [
    # Graphical Applications
    xpipe
    zed-editor
    mission-center
    # github-desktop
    # unstablePkgs.meld

    # Chromium
    (vivaldi.override {
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
    unstablePkgs.mqttui # MQTT TUI
    # unstablePkgs.zed-editor # IDE
    # unstablePkgs.tabiew # TUI Table Viewer (CSV, TSV, Parquet, etc.)
    testdisk

    # unstablePkgs.beeper # Universal Chat App
    unstablePkgs.chromium # Browser
    firefox-esr # Firefox
    gnome-boxes # VM Manager
    seahorse # GPG Key Manager
    # slack # Chat
    unstablePkgs.vesktop # Discord client w/ better wayland support (see nixcord.nix)
    virt-manager # VM Manager
    gnome-text-editor # Plain Text Editor
    file-roller # GUI Archive Manager
    vlc # Media Player
    loupe # Image Viewer
    mupdf # PDF (not native way

    # TODO: Reenable rustdesk after https://github.com/NixOS/nixpkgs/pull/390171 is merged
    # rustdesk
    # rustdesk-flutter # Remote Desktop
    obsidian # Note Taking
    unstablePkgs.remmina # RDP

    # System Tools
    qdirstat # Disk Usage Analyzer
    gparted # Partition Manager
    libsecret # Secret Service
    polkit_gnome # Polkit Agent
    unstablePkgs.rclone # cloud storage client
    rsync # file transfer

    # Dev Tools
    beekeeper-studio # SQL Client
    sqlite # Database
    mitmproxy # Proxy
    # prettier-d-slim # Prettier Daemon
    # unstablePkgs.nodePackages.wrangler
    (builtins.getFlake "github:NixOS/nixpkgs/8dfad603247387df1df4826b8bea58efc5d012d8").legacyPackages.${pkgs.system}.nodePackages.wrangler
    unstablePkgs.tree-sitter
    unstablePkgs.toolong # CLI to tail log files
    # unstablePkgs.tailspin # Log file highlighter
    unstablePkgs.lnav # Log file navigator
    git-trim # Trim your branches whose remote refs are merged or gone
    graphviz # Generate graphs on CLI
    kondo # Multi-language vendor file cleaner (node_modules, vendor, etc)
    just # Command runner
    # unstablePkgs.serie # Git Log output
    # unstablePkgs.mold # Faster Linker
    unstablePkgs.terraformer # Terraform Introspection Tool
    unstablePkgs.terraform # IaaC
    unstablePkgs.awscli2 # aws-cli
    # unstablePkgs.oha # HTML Load Tester
    turso-cli
    rdap # WHOIS replacement domain registration lookup service / CLI from the IETF
    wireshark # Packet Capture
    rpi-imager # RaspberyPi Flasher

    # Nix Tools
    nvd # Nix Visual Diff
    comma # Run commands in a nix-shell with comma prefix

    # Hardware Tools
    btop # system process monitor
    bottom # not top
    procs # process viewer
    bandwhich # network monitor
    # hyperfine # command-line benchmarking tool
    # gping # ping, but with a graph(TUI)
    doggo # DNS client for humans
    ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)
    gpu-viewer # GPU htop

    # Terminal Apps
    unstablePkgs.charm-freeze # Code Screenshots
    lazydocker # TUI Docker
    starship # Terminal Promps
    # hwatch # Interactive 'watch' alternative
    whois
    jq # CLI JSON Client
    cliphist # Clipboard History
    # irssi # IRC Client
    parted # GParted Terminal
    ranger # TUI File Manager
    speedtest-rs # Speedtest CLI
    systemctl-tui # Rust systemd TUI
    rose-pine-hyprcursor # Hyprland rose-pine cursor
    # unstablePkgs.yazi # Terminal File Manager
    # netscanner # TUI Subnet Scanner
    # unstablePkgs.termscp # TUI S3/SFTP/etc client
    # inputs.tsui.packages.${pkgs.system}.tsui # Tailscale TUI Client
    # inputs.superfile.packages.${pkgs.system}.default # TUI File Manager
    # inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    # inputs.isd.packages.${pkgs.system}.default # Interactive Systemd
  ];
}
