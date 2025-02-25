{ pkgs, lib, unstablePkgs, config, rose-pine-cursor, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    # Ex: https://github.com/vimjoyer/nixconf/blob/main/homeManagerModules/features/hyprland/default.nix
    # Ex with ${pkg}/bin/[binary] mapping example: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/hyprland/default.nix
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # xwayland.enable = true;
    # systemd.variables = [ "--all" ];

    systemd = {
      enable = false;
      variables = [ "--all" ];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    # plugins = [
    # unstablePkgs.hyprlandPlugins.hy3
    # (unstablePkgs.hyprlandPlugins.hy3.override {
    #   hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # })
    # Hyprfocus compilation broken until: https://github.com/pyt0xic/hyprfocus/pull/1 merged
    # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    # ];

    settings = {
      debug = {
        disable_logs = false;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      monitor = ",preferred,auto,auto";
      # Test multi-monitor: https://github.com/MatthiasBenaets/nix-config/blob/master/modules/desktops/hyprland.nix#L257
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRLAND_TRACE,1"
        "AQ_TRACE,1"

        # XDG Desktop Portal
        # "XDG_CURRENT_DESKTOP,Hyprland"
        # "XDG_SESSION_TYPE,wayland"
        # "XDG_SESSION_DESKTOP,Hyprland"

        # QT
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"

        # GDK
        "GDK_SCALE,1"

        # Toolkit Backend
        "GDK_BACKEND,wayland,x11,*"
        "CLUTTER_BACKEND,wayland"

        # Mozilla
        "MOZ_ENABLE_WAYLAND,1"

        # Disable appimage launcher by default
        # "APPIMAGELAUNCHER_DISABLE,1"

        # Ozone
        "OZONE_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      ];
      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 2;
        accel_profile = "adaptive";
      };
      exec = [
        "${unstablePkgs.swayosd}/bin/swayosd-server"
      ];
      exec-once = [
        # finalize startup
        "uwsm finalize"
        # "1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto  --silent"
        # "${lib.getExe pkgs._1password-gui} --silent"
        # "${pkgs.blueman}/bin/blueman-applet"
        "uwsm app -- waybar"
        "uwsm app -- ${pkgs.swaybg}/bin/swaybg -m fill -i ~/.config/hypr/wallpaper.png"
        "uwsm app -- ${lib.getExe unstablePkgs._1password-gui} --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto  --silent"
      ];
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 6;
        "col.active_border" = "rgb(11111b) rgb(181825) 45deg";
        "col.inactive_border" = "rgba(f5e0dc20)";

        no_focus_fallback = true;

        layout = "master";
        resize_on_border = true;
      };
      decoration = {
        rounding = 4;
        active_opacity = "0.94";
        inactive_opacity = "0.85";
        fullscreen_opacity = "1.0";

        dim_inactive = true;
        dim_strength = "0.075";

        shadow = {
          enabled = false;
        };

        blur = {
          enabled = true;
          xray = true;
          size = 8;
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
        };
      };
      group = {
        "col.border_active" = "rgb(181825)";
        "col.border_inactive" = "rgba(f5e0dc20)";

        groupbar = {
          render_titles = true;
          font_family = "Fira Sans Light";
          font_size = 10;
          height = 24;
          "col.active" = "rgb(181825)";
          "col.inactive" = "rgba(f5e0dc20)";
        };
      };
      animations = {
        enabled = "yes";
        bezier = [
          "linear, 1, 1, 0, 0"
        ];
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
        ];
      };
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        focus_on_activate = true;
        allow_session_lock_restore = true;
      };
      ecosystem = {
        no_donation_nag = true;
      };
      windowrule =
        let
          f = regex: "float, .*${regex}.*";
        in
        [
          (f "(D|d)ev(T|t)ools")
          (f "(b|B)eeper")
          (f "(g|G)it-(b|B)utler.*")
          (f "gitbutler-tauri")
          (f "Developer Tools")
          (f "Winetricks")
          (f "beekeeper-studio")
          (f "blueberry")
          (f "blueman")
          (f "lutris")
          (f "nemo")
          (f "nm-connection-editor")
          (f "opensnitch.*")
          (f "thunar")
          (f "org.gnome.Calculator")
          (f "org.gnome.FileRoller")
          (f "org.gnome.Loupe")
          (f "org.gnome.Nautilus")
          (f "org.gnome.Settings")
          (f "org.gnome.TextEditor")
          (f "org.ndom91.rustcast")
          (f "pavucontrol")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
        ] ++ [
          "float, file_progress"
          "float, confirm"
          "float, dialog"
          "float, download"
          "float, notification"
          "float, error"
          "float, splash"
          "float, confirmreset"
          "float, title:(S|s)ave (F|f)ile"
          "float, title:(O|o)pen (F|f)ile"
        ];
      windowrulev2 = [
        # General
        "animation fade, floating:1"

        # wlogout
        "float, title:wlogout"
        "fullscreen, title:wlogout"

        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^.*(Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        # 1Password Quick Access
        "stayfocused,title:^(Quick Access - 1Password)"
        "monitor DP-1,title:^(Quick Access - 1Password)"
        # "noinitialfocus,title:Quick Access - 1Password,floating"
        # "forceinput,title:^(Quick Access - 1Password)"

        # 1Password GUI
        "monitor DP-1,class:^(1Password)$"
        "center, class:^(1Password)$"
        "float, class:^(1Password)$"

        # idle inhibit while watching videos
        "idleinhibit focus, class:^(vivaldi)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(vivaldi)$"

        # portal / polkit
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "float, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
        "float, class:^(polkit-gnome-authentication-agent-1)$"
        "dimaround, class:^(gcr-prompter)$"
        "float, class:^(gcr-prompter)$"

        # xwaylandvideobridge - https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
      ];
      bind = [
        "$mainMod, G, togglegroup,"
        "$mainMod, U, changegroupactive,b"
        "$mainMod, I, changegroupactive,f"

        "$mainMod, Q, killactive"
        "CTRL SHIFT, L, exec, hyprlock"
        "$mainMod, Return, exec, ghostty"
        # "$mainMod SHIFT, R, exec, hyprctl reload"
        # "$mainMod, Return, exec, kitty"
        # "$mainMod SHIFT, F, exec, nemo"
        "$mainMod SHIFT, F, exec, thunar"
        "$mainMod SHIFT, Q, exec, wlogout -b 5 -c 0 -r 0 -m 0 --protocol layer-shell"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Space, cyclenext # hack to focus floating windows"
        "$mainMod, F, fullscreen, 1 # fullscreen type 1"
        "$mainMod, P, pseudo, # dwindle layout"
        "$mainMod, O, togglesplit, # dwindle layout"
        "$mainMod, D, exec, \"$HOME/.config/rofi/bin/launcher\""
        "$mainMod, E, exec, \"$HOME/.config/rofi/bin/emoji\""
        "$mainMod, C, exec, \"$HOME/.config/rofi/bin/cliphist\""
        "$mainMod, S, exec, \"$HOME/.config/rofi/bin/screenshot\""
        "$mainMod SHIFT, S, exec, pkill --signal SIGINT wf-recorder && notify-send \"Stopped Recording\" || wf-recorder -g \"$(slurp)\" -f ~/Videos/wfrecording_$(date +\"%Y-%m-%d_%H:%M:%S.mp4\") & notify-send \"Started Recording\" # start/stop video recording"

        # swaynotificationcenter
        "CTRL, Space, exec, swaync-client -t -sw"
        "CTRL SHIFT, Space, exec, swaync-client -C -sw"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod SHIFT, H, movewindoworgroup, l"
        "$mainMod SHIFT, L, movewindoworgroup, r"
        "$mainMod SHIFT, K, movewindoworgroup, u"
        "$mainMod SHIFT, J, movewindoworgroup, d"
        # "$mainMod SHIFT, J, movewindow, d"

        # Special Keys
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"

        # SwayOSD + AudioControl
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ]
      ++ (
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindn = [
        # 1Password Quick Search
        # "CTRL SHIFT, Period, exec, ${lib.getExe pkgs._1password-gui} --quick-access"
        # "CTRL SHIFT, Period, exec, 1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --quick-access"
        "CTRL SHIFT, Period, exec, ${lib.getExe unstablePkgs._1password-gui} --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --quick-access"
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
      binde = , H, resizeactive, 40 0
      binde = , L, resizeactive, -40 0
      binde = , K, resizeactive, 0 -40
      binde = , J, resizeactive, 0 40
      bind = , escape, submap, reset
      submap = reset

      # plugin {
      # hyprfocus {
      #   enabled = yes
      #
      #   focus_animation = shrink
      #
      #   bezier = bezIn, 0.5,0.0,1.0,0.5
      #   bezier = bezOut, 0.0,0.5,0.5,1.0
      #
      #   flash {
      #       flash_opacity = 0.8
      #
      #       in_bezier = bezIn
      #       in_speed = 0.5
      #
      #       out_bezier = bezOut
      #       out_speed = 3
      #   }
      #
      #   shrink {
      #     shrink_percentage = 0.995
      #
      #     in_bezier = bezIn
      #     in_speed = 0.25
      #
      #     out_bezier = bezOut
      #     out_speed = 1
      #   }
      # }
      # }
    '';
  };
}
