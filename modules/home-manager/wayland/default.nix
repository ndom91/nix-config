{ rose-pine-cursor, unstablePkgs, inputs, pkgs, ... }:
{
  imports = with rose-pine-cursor pkgs inputs; [
    ./hyprland/default.nix
    ./swaylock.nix
    ./wlogout.nix
    ./waybar/default.nix
    ./rofi/default.nix
  ];

  home.sessionVariables = {
    # WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Required for VMs
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    HYPRLAND_LOG_WLR = "1";
    GDK_BACKEND = "wayland,x11";

    # NixOS force Wayland for some apps
    NIXOS_OZONE_WL = "1";
    # Make qt apps expect wayland
    QT_QPA_PLATFORM = "wayland";

    # fix modals from being attached on tiling wms
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # fix java gui antialiasing
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  home.packages = with pkgs; [
    blueberry
    mkchromecast
    networkmanagerapplet
    playerctl
    swaybg
    swaynotificationcenter
    unstablePkgs.swayosd
    wf-recorder
    wl-clipboard
    wlr-randr
    wlsunset

    # Screenshot
    grim
    slurp
    swappy
    inputs.hyprland-contrib.packages."x86_64-linux".grimblast
  ];
}
