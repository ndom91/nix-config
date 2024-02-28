{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./polkit-gnome.nix
    ./waybar/default.nix
    ./rofi/default.nix
  ];

  # xresources.extraConfig
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    portal = {
      enable = true;
      config = {
        common = {
          default = [
            "Hyprland"
          ];
        };
      };
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
        # inputs.hyprland.packages."x86_64-linux".xdg-desktop-portal-gtk
        # inputs.hyprland.packages."x86_64-linux".xdg-desktop-portal-hyprland
      ];
      # configPackages = [
      #   inputs.hyprland.packages."x86_64-linux".hyprland
      # ];
      # extraPortals = [ 
      #   pkgs.xdg-desktop-portal-hyprland 
      # ];
      configPackages = [ pkgs.hyprland ];
    };
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
    swaylock-effects
    wlogout
    wl-clipboard
    wlsunset
    blueberry

    # Screenshot
    # grim
    # slurp
    swappy
    inputs.hyprland-contrib.packages."x86_64-linux".grimblast
  ];

  home.sessionVariables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    HYPRLAND_LOG_WLR = "1";
  };
}
