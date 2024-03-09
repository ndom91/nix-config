{ lib, pkgs, osConfig, ... }:
let
  ndo4Main = {
    output = "DP-1";
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
      on-scroll-down = "hyprctl dispatch workspace e-1";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      all-outputs = false;
    };
    cpu = {
      interval = 2;
      format = "<span font='15' rise='-1pt'>󰻠</span> {usage}%";
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
      interval = 5;
      format-wifi = "<span font='12' rise='-2pt'>󱚿</span> {ipaddr}";
      format-ethernet = " {bandwidthUpBits} |  {bandwidthDownBits}";
      format-alt = "<span font='12' rise='-2pt'>󰲐</span> {ipaddr}/{cidr}";
      format-linked = "󰖪 {ifname} (No IP)";
      format-disconnected = "󱛅 Disconnected";
      format-disabled = "󰖪 Disabled";
      tooltip-format = "󰀂 {ifname} via {gwaddr}";
      on-click-right = "nm-connection-editor";
    };
    "custom/weather" = {
      tooltip = true;
      format = "{}";
      interval = 30;
      exec = "~/.config/waybar/scripts/waybar-wttr.py";
      return-type = "json";
    };
    bluetooth = {
      format = "";
      format-connected = " {num_connections}";
      tooltip-format = "{device_alias}";
      tooltip-format-connected = " {device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}";
      on-click = "blueberry";
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
      format = "{:%H:%M | %a %b %d}";
      format-alt = " {:%a %b %d}";
      tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
    };
    wireplumber = {
      format = "<span font='12' rise='-2pt'></span> {volume}";
      format-muted = "<span font='12' rise='-2pt'></span>";
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

  ndo2Main = {
    output = "eDP-1";
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
      "battery"
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
      on-scroll-down = "hyprctl dispatch workspace e-1";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      all-outputs = false;
    };
    cpu = {
      interval = 2;
      format = "<span font='15' rise='-1pt'>󰻠</span> {usage}%";
      # format = "<span font='15' rise='-1pt'>󰻠</span> {usage =>2}%";
    };
    battery = {
      interval = 10;
      align = 0;
      rotate = 0;
      full-at = 95;
      design-capacity = false;
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-full = "{icon} Full";
      format-alt = "{icon} {time}";
      format-icons = [
        "<span font='12' rise='-2pt'>󰁺</span>"
        "<span font='12' rise='-2pt'>󰁻</span>"
        "<span font='12' rise='-2pt'>󰁼</span>"
        "<span font='12' rise='-2pt'>󰁽</span>"
        "<span font='12' rise='-2pt'>󰁾</span>"
        "<span font='12' rise='-2pt'>󰁿</span>"
        "<span font='12' rise='-2pt'>󰂀</span>"
        "<span font='12' rise='-2pt'>󰂁</span>"
        "<span font='12' rise='-2pt'>󰂂</span>"
        "<span font='12' rise='-2pt'>󰂄</span>"
      ];
      format-time = "{H}h {M}min";
      tooltip = true;
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
      interval = 5;
      format-wifi = "<span font='12' rise='-2pt'>󱚿</span> {ipaddr}";
      format-ethernet = " {bandwidthUpBits} |  {bandwidthDownBits}";
      format-alt = "<span font='12' rise='-2pt'>󰲐</span> {ipaddr}/{cidr}";
      format-linked = "󰖪 {ifname} (No IP)";
      format-disconnected = "󱛅 Disconnected";
      format-disabled = "󰖪 Disabled";
      tooltip-format = "󰀂 {ifname} via {gwaddr}";
      on-click-right = "nm-connection-editor";
    };
    "custom/weather" = {
      tooltip = true;
      format = "{}";
      interval = 30;
      exec = "~/.config/waybar/scripts/waybar-wttr.py";
      return-type = "json";
    };
    bluetooth = {
      format = "";
      format-disabled = "";
      format-connected = " {num_connections}";
      tooltip-format = "{device_alias}";
      tooltip-format-connected = " {device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}";
      on-click = "blueberry";
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
      format = "{:%H:%M | %a %b %d}";
      format-alt = " {:%a %b %d}";
      tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
    };
    wireplumber = {
      format = "<span font='12' rise='-2pt'></span> {volume}";
      format-muted = "<span font='12' rise='-2pt'></span>";
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

  ndo4Vertical = {
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
      spacing = 10;
    };
    clock = {
      interval = 60;
      align = 0;
      rotate = 0;
      format = "{:%H:%M | %a %b %d}";
      "format-alt" = " {:%a %b %d}";
      "tooltip-format" = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
    };
  };

  bars = lib.mkMerge [
    (lib.mkIf (osConfig.networking.hostName == "ndo4") {
      one = ndo4Main;
      two = ndo4Vertical;
    })
    (lib.mkIf (osConfig.networking.hostName == "ndo2") {
      one = ndo2Main;
    })
  ];
in
{

  xdg.configFile."waybar/scripts/waybar-wttr.py".source = ../../../../dotfiles/waybar/scripts/waybar-wttr.py;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    style = ./style.css;
    settings = bars;
  };
}
