{ pkgs, inputs, ... }:
{
  
  xdg.portal = {
    config = {
      common = {
        default = [
          "hyprland"
        ];
      };
    };
    enable = true;
    # extraPortals = [
    #   # pkgs.xdg-desktop-portal-gtk
    #   pkgs.xdg-desktop-portal-hyprland
    # ];
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    # configPackages = [ pkgs.inputs.hyprland.hyprland ];
  };


  wayland.windowManager.hyprland = {
    # Ex: https://github.com/vimjoyer/nixconf/blob/main/homeManagerModules/features/hyprland/default.nix
    # Ex with ${pkg}/bin/[binary] mapping example: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/hyprland/default.nix
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    enable = true;
    # hy3 not included in hyprland-plugins flake yet, see: https://github.com/hyprwm/hyprland-plugins
    # plugins = [
    #   inputs.hyprland-plugins.packages."${pkgs.system}".hy3
    # ];

    settings = {
      xwayland = {
        force_zero_scaling = true;
      };
      monitor = ",preferred,auto,auto";
      # monitor = ",highres,auto,1.7";
      # monitor = [
      #   "DP-1,3440x1440,1080x480,1"
      #   "DP-2,1920x1080,0x0,1,transform,3"
      # ];

      env = [
        "XCURSOR_SIZE,24"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        # "VDPAU_DRIVER,radeonsi"
        # "LIBVA_DRIVER_NAME,radeonsi"
      ];
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";

        # focus follow mouse
        follow_mouse = 2;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
        };

        sensitivity = 0;
      };
      exec-once = [
        # "${startupScript}/bin/start"
        "waybar"

        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
        "xrdb -merge ~/.Xresources"
        "xsetroot -xcf /usr/share/icons/BreezeX-RosePine-Linux/cursors/left_ptr 24"
        "hyprctl setcursor BreezeX-RosePine-Linux 24"
        "gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine-Linux'"
        "gsettings set org.gnome.desktop.interface cursor-size 24"

        "swaync"
        "1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto  --socket=wayland --silent"
        "nm-applet --indicator"
        "swaybg -m fill -i ~/.config/hypr/wallpapers/dark-purple-space-01.png"
        "swayidle -w"
        "mkchromecast -t"
        "swayosd"
        "wl-paste --watch cliphist store"
        "wlsunset -l 52.50 -L 12.76 -t 4500 -T 6500"
        "blueberry"

      ];
      # plugin = {
      #   hy3 = {
      #     tabs = {
      #       height = 5;
      #       padding = 8;
      #       render_text = false;
      #       col.active = "rgb(8a8dcc)";
      #     };
      #     autotile = {
      #       enable = true;
      #       trigger_width = 800;
      #       trigger_height = 500;
      #     };
      #   };
      # };
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 6;
        "col.active_border" = "rgb(11111b) rgb(181825) 45deg";
        "col.inactive_border" = "rgba(f5e0dc20)";

        # layout = "hy3";
        resize_on_border = true;
      };
      decoration = {
        rounded = 1;
        drop_shadow = false;
        active_opacity = 0.95;
        inactive_opacity = 0.80;
        fullscreen_opacity = 1.00;
      };
      animations = {
        enabled = "yes";
        bezier = [
          "smoothIn, 0.25, 1, 0.5, 1"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "windows, 1, 3, overshot"
          "windowsOut, 1, 4, smoothOut, slide"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };
      master = {
        new_is_master = true;
      };
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      windowrule = [
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "float, download"
        "float, notification"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Open File"
        "float, title:branchdialog"
        "float, Lxappearance"
        "float,viewnior"
        "float,feh"
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
      ];
      windowrulev2 = [
        "float, title:wlogout"
        "float, title:Annotator"
        "fullscreen, title:wlogout"

        "noshadow, floating:1"
        "noshadow, class:flemozi"
        "noborder, class:flemozi"
        "noblur, class:flemozi"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(brave-browser)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(brave-browser)$"

        # Trufflehog Chrome extension
        "float, title:Trufflehog"

        # float/slidein nemo file manager
        "animation slide, class:nemo"
        "float, class:nemo"
        # "size 30% 40%, class:nemo
        "center, class:nemo"

        # float/slidein Flemoji
        "animation slide, title:Flemoji"
        "float, title:Flemoji"

        # float/slidein pavucontrol
        "animation slide, class:pavucontrol"
        "float, class:pavucontrol"
        "size 30% 30%, class:pavucontrol"
        "center, class:pavucontrol"

        # float/slidein blueberry
        "animation slide, class:^(.*blueberry.*)$"
        "float, class:^(.*blueberry.*)$"
        # "size 20% 40%, class:^(.*blueberry.*)$
        "center, class:^(.*blueberry.*)$"

        # float/slidein blueman-manager
        "animation slide, class:^(blueman-.*)$"
        "float, class:^(blueman-.*)$"
        "size 20% 40%, class:^(blueman-.*)$"
        "center, class:^(blueman-.*)$"

        # float/slidein engrampa
        "animation slide, class:engrampa"
        "float, class:engrampa"
        "size 30% 40%, class:engrampa"
        "center, class:engrampa"

        # float imv
        "animation slide, class:imv"
        "float, class:imv"

        # float/slidein network-manager-editor
        "animation slide, class:nm-connection-editor"
        "float, class:nm-connection-editor"
        # "size 20% 30%, class:nm-connection-editor
        "center, class:nm-connection-editor"

        # float/slidein wofi
        "animation slide, class:wofi"
        "float, class:wofi"
        # "size 20% 30%, class:wofi
        # "noshadow, class:wofi
        "noborder, class:wofi"
        "noblur, class:wofi"
        "move 1430 50, class:wofi"
        "dimaround, title:Search..."

        "float, class:^(opensnitch_ui)$"
        "dimaround, class:^(opensnitch_ui)$"
        "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "dimaround, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "float, class:^(gcr-prompter)$"
        "dimaround, class:^(gcr-prompter)$"
        "float, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "size 1000 700, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "center, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "dimaround, class:^(org.freedesktop.impl.portal.desktop.kde)$"

        # DevTools
        "float, class:brave-browser, title:^(DevTools.*)$"
        "float, title:^(DevTools.*)$"

        # Winetricks
        "float, title:^(Winetricks.*)$"

        # Lutris
        "float, class:lutris"

        # YAD (Fusion360)
        "float, class:yad"

        # Beekeeper-Studio
        "float, class:beekeeper-studio"

        # Sharing indicator
        "animation slide, title:^.*(Sharing Indicator).*$"
        "float, title:^.*(Sharing Indicator).*$"
        "move 50% 100%-100, title:^.*(Sharing Indicator).*$"

        "animation slide, title:^.*(sharing your screen).*$"
        "float, title:^.*(sharing your screen).*$"
        "move 50% 100%-100, title:^(.*sharing your screen.*)$"

        # xwaylandvideobridge - https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
      ];
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, D, exec, \"$HOME/.config/rofi/bin/launcher\""
        "$mainMod, M, exec, flemozi"
        # "$mainMod, T, hy3:makegroup, tab, force_ephemeral"
        # "$mainMod, Y, hy3:changegroup, opposite"
        "$mainMod, Q, killactive"
        # "$mainMod, Q, hy3:killactive,"
        # "$mainMod, Return, exec, alacritty
        "$mainMod, Return, exec, wezterm"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        "$mainMod SHIFT, F, exec, nemo"
        "$mainMod SHIFT, Q, exec, wlogout --protocol layer-shell"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Space, cyclenext # hack to focus floating windows"
        "$mainMod, F, fullscreen, 1 # fullscreen type 1"
        "$mainMod, P, pseudo, # dwindle layout"
        "$mainMod, O, togglesplit, # dwindle layout"
        "$mainMod, S, exec, '$HOME/.config/rofi/bin/screenshot'"
        "$mainMod SHIFT, S, exec, pkill --signal SIGINT wf-recorder && notify-send \"Stopped Recording\" || wf-recorder -g \"$(slurp)\" -f ~/Videos/wfrecording_$(date +\"%Y-%m-%d_%H:%M:%S.mp4\") & notify-send \"Started Recording\" # start/stop video recording"
        "$mainMod, C, exec, \"$HOME/.config/rofi/bin/cliphist\""
        "CTRL SHIFT, L, exec, swaylock -f"

        # notifications mako
        # "CTRL, `, exec, makoctl restore
        # "CTRL SHIFT, Space, exec, makoctl dismiss -a
        # "CTRL, Space, exec, makoctl dismiss

        # notifications swaync
        "CTRL, Space, exec, swaync-client -t -sw"
        "CTRL SHIFT, Space, exec, swaync-client -C -sw"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        # "$mainMod, H, exec, /home/ndo/.config/hypr/movefocus.sh l"
        # "$mainMod, L, exec, /home/ndo/.config/hypr/movefocus.sh r"
        # "$mainMod, K, hy3:movefocus, u"
        # "$mainMod, J, hy3:movefocus, d"

        # "$mainMod SHIFT, H, hy3:movewindow, l"
        # "$mainMod SHIFT, L, hy3:movewindow, r"
        # "$mainMod SHIFT, K, hy3:movewindow, u"
        # "$mainMod SHIFT, J, hy3:movewindow, d"
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Special Keys
        ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",xf86audioplay, exec, playerctl play-pause"
        ",xf86audionext, exec, playerctl next"
        ",xf86audioprev, exec, playerctl previous"
        ",xf86audiostop, exec, playerctl stop"
        # SwayOSD
        ",XF86AudioRaiseVolume,exec,swayosd --output-volume raise"
        ",XF86AudioLowerVolume,exec,swayosd --output-volume lower"
        ",XF86AudioMute,exec,swayosd --output-volume mute-toggle"
        ",XF86AudioMicMute,exec,swayosd --input-volume mute-toggle"
        ",xf86audioplay, exec, playerctl play-pause"
        ",xf86audionext, exec, playerctl next"
        ",xf86audioprev, exec, playerctl previous"
        ",xf86audiostop, exec, playerctl stop"
      ];
      bindn = [
        # 1Password Quick Search - NOT WORKING
        "CTRL SHIFT, Period, exec, 1password --quick-access"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      "$mainMod" = "SUPER";
    };
    extraConfig = ''
      # Resize
      bind = $mainMod, R, submap, resize
      submap = resize
      binde = , H, resizeactive, -40 0
      binde = , L, resizeactive, 40 0
      binde = , K, resizeactive, 0 -40
      binde = , J, resizeactive, 0 40
      bind = , escape, submap, reset
      submap = reset
    '';
  };
  home.packages = with pkgs; [
    xorg.xrdb
    xorg.xsetroot
    xorg.xprop
    swaynotificationcenter
    _1password-gui
    networkmanagerapplet
    playerctl
    swaybg
    swayidle
    mkchromecast
    swayosd
    wl-clipboard
    wlsunset
    blueberry

    # Screenshot
    # grim
    # slurp
    swappy
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];
}
