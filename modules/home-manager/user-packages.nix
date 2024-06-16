{ inputs, config, unstablePkgs, pkgs, ... }:
let
  vivaldi-snapshot = pkgs.callPackage ../../packages/vivaldi-snapshot/default.nix { };
in
{

  home.packages = with pkgs; [
    # Graphical Applications
    unstablePkgs.xpipe

    vivaldi-snapshot
    # Chromium
    # (unstablePkgs.vivaldi.override {
    #   isSnapshot = true;
    #   proprietaryCodecs = true;
    #   enableWidevine = true;
    #   commandLineArgs = [
    #     "--enable-features=UseOzonePlatform"
    #     "--ozone-platform=wayland"
    #     #   "--ozone-platform=wayland"
    #     #   "--enable-features=VaapiVideoDecoder"
    #     #   "--use-gl=egl"
    #     #
    #     #   "--use-gl=angle"
    #     #   "--use-angle=gl"
    #     #   "--ignore-gpu-blacklist"
    #     #   "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,RawDraw,CanvasOopRasterization"
    #     #   "--enable-gpu-rasterization"
    #     #   "--enable-zero-copy"
    #     #   "--enable-hardware-overlays"
    #     #   "--enable-native-gpu-memory-buffers"
    #     #   "--enable-webrtc-pipewire-capturer"
    #   ];
    # })

    # Experimental
    unstablePkgs.flameshot

    floorp # Firefox
    gnome.gnome-boxes # VM Manager
    gnome.seahorse # GPG Key Manager
    slack # Chat
    vesktop # Discord fork
    virt-manager # VM Manager
    gnome-text-editor # Plain Text Editor
    cinnamon.nemo # GUI File Manager
    gnome.file-roller # GUI Archive Manager
    vlc # Media Player
    unstablePkgs.protonvpn-gui # VPN Client

    rustdesk # Remote Desktop
    obsidian # Note Taking

    # System Tools
    qdirstat # Disk Usage Analyzer
    gparted # Partition Manager
    libsecret # Secret Service
    polkit_gnome # Polkit Agent

    # Dev Tools
    beekeeper-studio # SQL Client
    sqlite # Database
    mitmproxy # Proxy
    prettier-d-slim # Prettier Daemon
    # unstablePkgs.nodePackages.wrangler
    (builtins.getFlake "github:NixOS/nixpkgs/8dfad603247387df1df4826b8bea58efc5d012d8").legacyPackages.${pkgs.system}.nodePackages.wrangler

    # Nix Tools
    nvd # Nix Visual Diff
    unstablePkgs.nh # Nix History
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
    unstablePkgs.netscanner # TUI Subnet Scanner
    unstablePkgs.termscp # TUI S3/SFTP/etc client
    unstablePkgs.oha # HTML Load Tester
    inputs.superfile.packages.${system}.default # TUI File Manager

    # Fonts
    (unstablePkgs.nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" "JetBrainsMono" "FiraCode" "FiraMono" "GeistMono" "Hack" "Ubuntu" "UbuntuMono" ]; })
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd
    fira
    noto-fonts-color-emoji

    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  # All Chromium command line switches: https://peter.sh/experiments/chromium-command-line-switches/
  xdg.desktopEntries = {
    vivaldi = {
      name = "Vivaldi Wayland";
      exec = "${unstablePkgs.vivaldi}/bin/vivaldi " +
        "--enable-features=UseOzonePlatform " +
        "--ozone-platform=wayland" +
        "%U";

      # "--use-gl=angle " +
      # "--use-angle=gl " +
      # "--ignore-gpu-blacklist " +
      # "--enable-gpu-rasterization " +
      # "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,RawDraw,CanvasOopRasterization,UseOzonePlatform " +
      # "--enable-gpu-rasterization " +
      # "--enable-zero-copy " +
      # "--enable-hardware-overlays " +
      # "--enable-native-gpu-memory-buffers " +
      # "--enable-webrtc-pipewire-capturer " +
      genericName = "Web Browser";
      startupNotify = true;
      terminal = false;
      icon = "vivaldi";
      type = "Application";
      categories = [ "Network" "WebBrowser" ];
      mimeType = [
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "text/html"
        "text/xml"
        "x-scheme-handler/ftp"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
      ];
    };
    beeper = {
      name = "Beeper";
      exec = "/opt/appimages/beeper.AppImage";
      icon = "beeper";
      type = "Application";
      categories = [ "Network" "WebBrowser" ];
    };
  };

  programs.bash.sessionVariables.FLAKE = "/etc/nixos$(hostname)";
}
