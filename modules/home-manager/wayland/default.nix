{ inputs, pkgs, ... }:
{
  imports = with pkgs inputs; [
    ./hyprland.nix
    ./swaylock.nix
    ./wlogout.nix
    ./polkit-gnome.nix
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
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # WLR_RENDERER_ALLOW_SOFTWARE = "1";
    HYPRLAND_LOG_WLR = "1";
  };

  home.packages = with pkgs; [
    swaynotificationcenter
    _1password-gui
    networkmanagerapplet
    playerctl
    swaybg
    swayidle
    swayosd
    wf-recorder
    mkchromecast
    swayosd
    wl-clipboard
    wlsunset
    wlr-randr
    blueberry

    # Screenshot
    # grim
    # slurp
    swappy
    inputs.hyprland-contrib.packages."x86_64-linux".grimblast
  ];
}
