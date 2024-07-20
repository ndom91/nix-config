{ rose-pine-cursor, config, lib, unstablePkgs, inputs, pkgs, ... }:
{
  imports = with rose-pine-cursor pkgs inputs; [
    ./hyprland/default.nix
    ./waybar/default.nix
    ./rofi/default.nix
    ./hyprlock.nix
    ./swaync.nix
    ./wlogout.nix
  ];

  home.sessionVariables = {
    # WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Required for VMs

    # Make qt apps expect wayland
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";

    HYPRLAND_LOG_WLR = "1";
    GDK_BACKEND = "wayland,x11";

    XCURSOR_SIZE = "24";

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
    hypridle = {
      enable = true;
      settings = {
        general = {
          # avoid starting multiple hyprlock instances.
          lock_cmd = "pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          # lock before suspend.
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          # to avoid having to press a key twice to turn on the display.
          after_sleep_cmd = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
        };
        listener = [
          {
            # Alert that lock is incoming
            timeout = 590;
            command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 10000";
          }
          {
            # Lock the screen
            timeout = 600;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
            # on-timeout = "${config.programs.hyprlock.package}/bin/hyprlock";
          }
          {
            # 60s later, turn off the screen
            timeout = 660;
            on-timeout = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            # At 1hr idle, suspend-then-hibernate
            timeout = 3600;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
          }
        ];
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
