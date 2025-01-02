{ pkgs, lib, unstablePkgs, config, rose-pine-cursor, inputs, ... }:
{

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

  wayland.windowManager.hyprland = {
    # Ex: https://github.com/vimjoyer/nixconf/blob/main/homeManagerModules/features/hyprland/default.nix
    # Ex with ${pkg}/bin/[binary] mapping example: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/hyprland/default.nix
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    systemd.variables = [ "--all" ];

    plugins = [
      # unstablePkgs.hyprlandPlugins.hy3
      # (unstablePkgs.hyprlandPlugins.hy3.override {
      #   hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # })
      # Hyprfocus compilation broken until: https://github.com/pyt0xic/hyprfocus/pull/1 merged
      # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];

    settings = {
      debug = {
        disable_logs = true;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      monitor = ",preferred,auto,auto";
      # Test multi-monitor: https://github.com/MatthiasBenaets/nix-config/blob/master/modules/desktops/hyprland.nix#L257

      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
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
        # "1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto  --silent"
        "${lib.getExe pkgs._1password-gui} --silent"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.swaybg}/bin/swaybg -m fill -i ~/.config/hypr/wallpaper.png"
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
          popups = true;
          new_optimizations = true;
        };
      };
      group = {
        "col.border_active" = "rgb(181825)";
        "col.border_inactive" = "rgba(f5e0dc20)";

        groupbar = {
          render_titles = true;
          font_family = "Fira Sans Light";
          font_size = 9;
          height = 24;
          "col.active" = "rgb(181825)";
          "col.inactive" = "rgba(f5e0dc20)";
        };
      };
      animations = {
        enabled = "yes";
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "linear, 0.0, 0.0, 1.0, 1.0"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "slow, 0, 0.85, 0.3, 1"
          "overshot, 0.7, 0.6, 0.1, 1.1"
          "bounce, 1.1, 1.6, 0.1, 0.85"
          "sligshot, 1, -1, 0.15, 1.25"
          "nice, 0, 6.9, 0.5, -4.20"

          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
        ];

        animation = [
          "windowsIn, 1, 5, slow, popin"
          "windowsOut, 1, 5, winOut, popin"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 10, linear"
          "fade, 1, 5, overshot"
          "workspaces, 1, 5, wind"
          "windows, 1, 5, bounce, popin"

          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layers, 1, 2, md3_decel, slide"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
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
      # windowrule = [
      #   "float, file_progress"
      #   "float, confirm"
      #   "float, dialog"
      #   "float, download"
      #   "float, notification"
      #   "float, error"
      #   "float, splash"
      #   "float, confirmreset"
      # ];
      windowrule =
        let
          # f = regex: "float, ^(${regex})$";
          f = regex: "float, .*${regex}.*";
        in
        [
          (f "(D|d)ev(T|t)ools")
          (f "(b|B)eeper")
          (f "(g|G)it-(b|B)utler.*")
          (f "Developer Tools")
          (f "Winetricks")
          (f "beekeeper-studio")
          (f "blueberry")
          (f "blueman")
          (f "lutris")
          (f "nemo")
          (f "nm-connection-editor")
          (f "opensnitch.*")
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
        # "$mainMod, Return, exec, kitty"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        # "$mainMod SHIFT, F, exec, nemo"
        "$mainMod SHIFT, F, exec, nautilus"
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
        "CTRL SHIFT, Period, exec, ${lib.getExe pkgs._1password-gui} --quick-access"
        # "CTRL SHIFT, Period, exec, 1password --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --quick-access"
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

      plugin {
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
      }
    '';
  };
}
