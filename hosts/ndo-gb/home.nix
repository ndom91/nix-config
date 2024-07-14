{ fira-sans-nerd-font, rose-pine-cursor, nix-colors, lib, inputs, stateVersion, config, pkgs, unstablePkgs, ... }:
{
  imports = with rose-pine-cursor inputs pkgs unstablePkgs; [
    nix-colors.homeManagerModules.default
    ../../modules/home-manager/default.nix
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

  # ndo-gb overrides
  wayland.windowManager.hyprland = {
    settings = {
      monitor = lib.mkForce [
        "eDP-1,preferred,auto,1"
        "DP-2,preferred,auto,1"
      ];
      workspace = [
        "1,monitor:eDP-1,default:true"
        "2,monitor:eDP-1"
        "3,monitor:DP-2,default:true"
      ];
      exec-once = [
        "${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1.5"
      ];
      bindl = [
        # trigger when the switch is turning on
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,disable'"
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor 'eDP-1,preferred,auto,1'"
      ];
      bind = [
        ",XF86Launch2, exec, /home/ndo/.config/rofi/bin/screenshot"
      ];
      input = {
        touchpad = {
          clickfinger_behavior = true;
        };
      };
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

