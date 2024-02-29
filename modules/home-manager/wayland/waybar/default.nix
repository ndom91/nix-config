{ pkgs, ... }:
let
  mainWaybarConfig = {
    # output = "DP-1";
    layer = "top";
    exclusive = true;
    passthrough = false;
    position = "top";
    fixed-center = true;
    ipc = true;
    margin-left = 5;
    margin-right = 5;
    margin-top = 5;
    margin-bottom = 0;
    height = 35;
    modules-left = [
      "clock"
      "cpu"
      "memory"
      "disk"
      "hyprland/workspaces"
      "hyprland/submap"
    ];
    modules-center = [
      "hyprland/window"
    ];
    modules-right = [
      "bluetooth"
      "custom/weather"
      "network"
      "pulseaudio"
      "tray"
    ];
    "wlr/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "10";
        urgent = "";
        active = "";
        default = "";
      };
      persistent_workspaces = "{'1','2','3','4','5'}";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";
      all-outputs = false;
    };
    cpu = {
      interval = 1;
      format = "<span font='15' rise='-1pt'>󰻠</span> {usage}%";
      # format = "<span font='15' rise='-1pt'>󰻠</span> {usage =>2}%";
    };
    "custom/menu" = {
      format = "⮝";
      on-click = "$HOME/.config/hypr/scripts/menu";
      tooltip = false;
    };
    disk = {
      interval = 120;
      format = "<span font='15' rise='-1pt'>󰋊</span> {free}";
    };
    memory = {
      interval = 10;
      format = "<span font='13' rise='-1pt'></span> {percentage}%";
    };
    "hyprland/window" = {
      format = "{}";
      separate-outputs = true;
    };
    "hyprland/submap" = {
      format = "{}";
      max-length = 8;
      tooltip = false;
    };
    network = {
      interval = 1;
      format-wifi = "<span font='15' rise='-2pt'></span> {ipaddr}";
      format-ethernet = " {bandwidthUpBits} |  {bandwidthDownBits}";
      format-alt = "<span font='15' rise='-2pt'></span> {ipaddr}/{cidr}";
      format-linked = " {ifname} (No IP)";
      format-disconnected = "睊 Disconnected";
      format-disabled = "睊 Disabled";
      tooltip-format = " {ifname} via {gwaddr}";
      on-click-right = "nm-connection-editor";
    };
    "custom/weather" = {
      tooltip = true;
      format = "{}";
      interval = 30;
      exec = "~/.config/waybar/scripts/waybar-wttr.py";
      return-type = "json";
    };
    "custom/updater" = {
      format = "<span font='15' rise='-2pt'></span> {}";
      exec = "checkupdates-with-aur | uniq | wc -l";
      interval = 14400;
      tooltip = false;
    };
    "custom/cycle_wall" = {
      format = "";
      on-click = "~/.config/hypr/scripts/changeWallpaper";
      tooltip-format = "Change wallpaper";
    };
    "custom/keybindings" = {
      format = "爵";
      tooltip = false;
      on-click = "~/.config/hypr/scripts/keyhint";
    };
    bluetooth = {
      format = "";
      format-disabled = "";
      format-connected = " {num_connections}";
      tooltip-format = "{device_alias}";
      tooltip-format-connected = " {device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}";
      on-click-right = "blueberry";
    };
    tray = {
      icon-size = 16;
      show-passive-items = true;
      spacing = 10;
    };
    clock = {
      interval = 60;
      align = 0;
      rotate = 0;
      format = "🕐 {:%H:%M | %a %b %d}";
      format-alt = " {:%a %b %d}";
      tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
    };
    wireplumber = {
      format = "<span font='15' rise='-2pt'></span> {volume}";
      format-muted = "<span font='15' rise='-2pt'></span>";
      on-click = "pavucontrol";
    };
    pulseaudio = {
      format = "<span font='15' rise='-2pt'></span>  {volume}";
      format-muted = "<span font='15' rise='-2pt'></span>";
      format-bluetooth = "<span font='15' rise='-2pt'></span> {volume}% {format_source}";
      format-bluetooth-muted = "<span font='15' rise='-2pt'></span> Muted";
      format-icons = {
        hands-free = "";
        headphone = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          "<span font='20' rise='-5pt'>奄</span>"
          "<span font='20' rise='-5pt'>奔</span>"
          "<span font='20' rise='-5pt'>墳</span>"
          "<span font='20' rise='-5pt'>墳</span>"
        ];
      };
      scroll-step = 5;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
      on-scroll-up = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
      on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      smooth-scrolling-threshold = 1;
    };
  };

  verticalWaybarConfig = {
    output = "DP-2";
    layer = "top";
    exclusive = true;
    passthrough = false;
    position = "top";
    fixed-center = true;
    ipc = true;
    margin-left = 5;
    margin-right = 5;
    margin-top = 5;
    margin-bottom = 0;
    height = 35;
    modules-left = [
      "clock"
    ];
    modules-center = [
      "hyprland/window"
    ];
    modules-right = [
      "tray"
    ];
    tray = {
      "icon-size" = 16;
      "spacing" = 10;
    };
    clock = {
      interval = 60;
      align = 0;
      rotate = 0;
      format = "🕐 {:%H:%M | %a %b %d}";
      "format-alt" = " {:%a %b %d}";
      "tooltip-format" = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
    };
    wireplumber = {
      format = "<span font='15' rise='-2pt'></span> {volume}";
      "format-muted" = "<span font='15' rise='-2pt'></span>";
      "on-click" = "pavucontrol";
    };
    pulseaudio = {
      format = "<span font='15' rise='-2pt'></span>  {volume}";
      "format-muted" = "<span font='15' rise='-2pt'></span>";
      "format-bluetooth" = "<span font='15' rise='-2pt'></span> {volume}% {format_source}";
      "format-bluetooth-muted" = "<span font='15' rise='-2pt'></span> Muted";
      "format-icons" = {
        "headphone" = "";
        "hands-free" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = [
          "<span font='20' rise='-5pt'>奄</span>"
          "<span font='20' rise='-5pt'>奔</span>"
          "<span font='20' rise='-5pt'>墳</span>"
          "<span font='20' rise='-5pt'>墳</span>"
        ];
      };
      "scroll-step" = 5;
      "on-click" = "pamixer -t";
      "on-click-right" = "pavucontrol";
      "on-scroll-up" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
      "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "smooth-scrolling-threshold" = 1;
    };
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    style = ./style.css;
    settings = { mainBar = mainWaybarConfig; };
    # settings = { mainBar = mainWaybarConfig; verticalBar = verticalWaybarConfig; };
  };
}
