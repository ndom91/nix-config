{ rose-pine-cursor, unstablePkgs, inputs, pkgs, ... }:
{
  imports = with rose-pine-cursor pkgs inputs; [
    ./hyprland.nix
    ./swaylock.nix
    ./wlogout.nix
    # ./polkit-gnome.nix
    ./waybar/default.nix
    ./rofi/default.nix
  ];

  # xresources.extraConfig
  # xdg = {
  #   userDirs = {
  #     enable = true;
  #     createDirectories = true;
  #   };
  #   portal = {
  #     enable = true;
  #     config = {
  #       common = {
  #         default = [
  #           "Hyprland"
  #         ];
  #       };
  #     };
  #     xdgOpenUsePortal = true;
  #     extraPortals = [
  #       pkgs.xdg-desktop-portal-gtk
  #       pkgs.xdg-desktop-portal-hyprland
  #       # inputs.hyprland.packages."x86_64-linux".xdg-desktop-portal-gtk
  #       # inputs.hyprland.packages."x86_64-linux".xdg-desktop-portal-hyprland
  #     ];
  #     # configPackages = [
  #     #   inputs.hyprland.packages."x86_64-linux".hyprland
  #     # ];
  #     # extraPortals = [ 
  #     #   pkgs.xdg-desktop-portal-hyprland 
  #     # ];
  #     # configPackages = [ pkgs.hyprland ];
  #   };
  # };

  # make stuff work on wayland
  home.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # WLR_RENDERER_ALLOW_SOFTWARE = "1";
    HYPRLAND_LOG_WLR = "1";
    GDK_BACKEND = "wayland,x11";
    # some nixpkgs modules have wrapers
    # that force electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # make qt apps expect wayland
    QT_QPA_PLATFORM = "wayland";

    # fix modals from being attached on tiling wms
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # fix java gui antialiasing
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  home.packages = with pkgs; [
    # swayosd
    _1password-gui
    blueberry
    mkchromecast
    networkmanagerapplet
    playerctl
    swaybg
    swayidle
    swaynotificationcenter
    unstablePkgs.swayosd
    wf-recorder
    wl-clipboard
    wlr-randr
    wlsunset

    # Screenshot
    # grim
    # slurp
    swappy
    inputs.hyprland-contrib.packages."x86_64-linux".grimblast
  ];
}
