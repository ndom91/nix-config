{ config, unstablePkgs, pkgs, ... }:
{

  home.packages = with pkgs; [
    # Graphical Applications
    unstablePkgs.xpipe
    (unstablePkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    floorp
    gnome.gnome-boxes
    gnome.seahorse
    slack
    vesktop # Discord fork
    virt-manager
    gnome-text-editor
    cinnamon.nemo
    gnome.file-roller
    vlc
    unstablePkgs.protonvpn-gui

    rustdesk
    obsidian

    # System Tools
    qdirstat
    gparted
    libsecret
    polkit_gnome

    # Dev Tools
    beekeeper-studio
    sqlite
    mitmproxy

    # Nix Tools
    nvd
    unstablePkgs.nh
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
    gpu-viewer

    # Terminal Apps
    lazygit
    lazydocker
    starship
    whois
    jq
    cliphist
    irssi
    parted
    ranger

    # Fonts
    (unstablePkgs.nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" "JetBrainsMono" "FiraCode" "FiraMono" "GeistMono" "Hack" "Ubuntu" "UbuntuMono" ]; })
    fira
    noto-fonts-color-emoji

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # All Chromium command line switches: https://peter.sh/experiments/chromium-command-line-switches/
  xdg.desktopEntries = {
    vivaldi = {
      name = "Vivaldi Wayland";
      exec = "${unstablePkgs.vivaldi}/bin/vivaldi --use-gl=angle --use-angle=gl --ignore-gpu-blacklist --enable-gpu-rasterization --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiVideoEncoder,RawDraw,CanvasOopRasterization --enable-gpu-rasterization --enable-zero-copy --enable-hardware-overlays --enable-native-gpu-memory-buffers --enable-webrtc-pipewire-capturer %U";
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
  };

  programs.bash.sessionVariables.FLAKE = "/etc/nixos$(hostname)";
}
