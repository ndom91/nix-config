{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, config, pkgs, stateVersion, unstablePkgs, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    inputs.catppuccin.homeManagerModules.catppuccin
    nix-colors.homeManagerModules.default
    ../../modules/home-manager
  ];

  home = {
    username = "ndo";
    homeDirectory = "/home/ndo";
    stateVersion = stateVersion;
    packages = [
      inputs.home-manager.packages.x86_64-linux.home-manager # home-manager binary
      fira-sans-nerd-font
    ];
  };

  # systemd.user.sessionVariables = config.home.sessionVariables;
  systemd.user.startServices = "sd-switch";

  # Themes - https://github.com/tinted-theming/base16-schemes
  colorScheme = nix-colors.colorSchemes.rose-pine;

  # ndo2 overrides
  wayland.windowManager.hyprland = {
    settings = {
      # monitor = lib.mkForce "eDP-1,preferred,auto, 1.600000";
      monitor = lib.mkForce [
        "eDP-1,preferred,auto-left,1.600000"
        "DP-2,preferred,auto,1"
      ];
      env = lib.mkForce [
        "GDK_SCALE,1.6"
      ];
      # debug = {
      #   disable_scale_checks = true;
      # };
      # exec-once = [
      #   "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1.6"
      # ];
      bindl = [
        # trigger when the switch is turning on
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,disable'"
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,preferred,auto,1.600000'"
      ];
      input = {
        touchpad = {
          clickfinger_behavior = true;
        };
      };
      # "device:MSFT0001:00 04F3:31EB Touchpad" = {
      #   accel_profile = "adaptive";
      #   natural_scroll = true;
      #   sensitivity = 0.1;
      # };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 200;
        workspace_swipe_create_new = false;
      };
    };
  };

  services = {
    network-manager-applet.enable = true;
  };

  programs.home-manager.enable = true;
}
