{ rose-pine-cursor, config, lib, unstablePkgs, inputs, pkgs, ... }:
{
  imports = with rose-pine-cursor pkgs inputs; [
    # Hyprland
    ./waybar/default.nix
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./swaync.nix

    ./rofi/default.nix
    ./wlogout.nix
  ];

  home.sessionVariables = {
    # WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Required for VMs

    # NixOS force Wayland for some apps
    NIXOS_OZONE_WL = "1";
    # MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";

    # fix modals from being attached on tiling wms
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # fix java gui antialiasing
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  services = {
    cliphist.enable = true;
    wlsunset = {
      enable = true;
      latitude = "52.52";
      longitude = "13.40";
      temperature = {
        day = 6500;
        night = 4500;
      };
    };
  };

  home.packages = with pkgs; [
    # blueberry
    evtest # Input event debugging
    mkchromecast # Chromecast
    playerctl # Media player control
    swaybg # Set background on boot
    swaynotificationcenter # Notification center
    swayosd # Media OSD
    wdisplays # Graphical Display Configuration
    wev # Show wayland events
    wf-recorder # Wayland screen recorder
    wl-clipboard # Wayland clipboard
    wl-mirror # Wayland screen mirror
    wlr-randr # Wayland xrandr alternative

    # Screenshot toolchain
    grim # Grab images from Wayland compositors
    slurp # Select a region from Wayland compositors
    swappy # Annotate image from Wayland compositors
    satty # Better annotate image from Wayland compositors
  ];

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=true
    line_size=8
    text_size=24
    text_font=sans-serif
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
}
