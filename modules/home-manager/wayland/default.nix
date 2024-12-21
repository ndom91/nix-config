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
    MOZ_ENABLE_WAYLAND = "1";

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
    evtest
    mkchromecast
    playerctl
    swaybg
    unstablePkgs.swaynotificationcenter
    unstablePkgs.swayosd
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wl-mirror
    wlr-randr

    # Screenshot
    grim
    slurp
    swappy
  ];
}
