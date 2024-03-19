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
    margin-left = 20;
    margin-right = 20;
    margin-top = 10;
    margin-bottom = 0;
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
      "idle_inhibitor"
      "bluetooth"
      "custom/weather"
      "network"
      "wireplumber"
      "custom/notification"
      "tray"
    ];
    "hyprland/workspaces" = {
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
        # active = "";
        # default = "";
      };
      persistent-workspaces = {
        "DP-1" = [ 2 3 ];
        "DP-2" = [ 1 ];
      };
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
      format = "<span font='14' rise='-1pt'>󰋊</span> {free}";
    };
    memory = {
      interval = 10;
      format = "<span font='12' rise='0pt'></span> {percentage}%";
    };
    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "󰛊";
        deactivated = "󰾫";
      };
      tooltip = true;
      tooltip-format-activated = "Idle Inhibitor {status}";
      tooltip-format-deactivated = "Idle Inhibitor {status}";
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon} {}";
      format-icons = {
        notification = "<span font='8' foreground='red'></span>";
        none = "";
        dnd-notification = "<span font='8' foreground='red'></span>";
        dnd-none = "";
        inhibited-notification = "<span font='8' foreground='red'></span>";
        inhibited-none = "";
        dnd-inhibited-notification = "<span font='8' foreground='red'></span>";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
      on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
      on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
      escape = true;
    };
    "hyprland/window" = {
      format = "{}";
      max-length = 80;
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
      on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
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
      on-click-right = "${pkgs.blueberry}/bin/blueberry";
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
      on-click = "${pkgs.pamixer}/bin/pamixer -t";
      on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
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
      on-click = "${pkgs.pamixer}/bin/pamixer -t";
      on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
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
    margin-left = 20;
    margin-right = 20;
    margin-top = 10;
    margin-bottom = 0;
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
      "idle_inhibitor"
      "bluetooth"
      "custom/weather"
      "network"
      "wireplumber"
      "custom/notification"
      "tray"
    ];
    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "󰛊";
        deactivated = "󰾫";
      };
      tooltip = true;
      tooltip-format-activated = "Idle Inhibitor {status}";
      tooltip-format-deactivated = "Idle Inhibitor {status}";
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon} {}";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>";
        none = "";
        dnd-notification = "<span foreground='red'><sup></sup></span>";
        dnd-none = "";
        inhibited-notification = "<span foreground='red'><sup></sup></span>";
        inhibited-none = "";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
      on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
      on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
      escape = true;
    };
    "hyprland/workspaces" = {
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
        # active = "";
        # default = "";
      };
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
        warning = 20;
        critical = 10;
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
      format = "<span font='14' rise='-1pt'>󰋊</span> {free}";
    };
    memory = {
      interval = 10;
      format = "<span font='13' rise='-2pt'></span> {percentage}%";
    };
    "hyprland/window" = {
      format = "{}";
      max-length = 80;
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
      on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
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
      on-click-right = "${pkgs.blueberry}/bin/blueberry";
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
      on-click = "${pkgs.pamixer}/bin/pamixer -t";
      on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
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
      on-click = "${pkgs.pamixer}/bin/pamixer -t";
      on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
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
    margin-left = 20;
    margin-right = 20;
    margin-top = 10;
    margin-bottom = 0;
    modules-left = [
      "clock"
      "hyprland/workspaces"
    ];
    modules-center = [
      "hyprland/window"
    ];
    modules-right = [
      "network"
    ];
    network = {
      interval = 5;
      format-wifi = "<span font='12' rise='-2pt'>󱚿</span> {ipaddr}";
      format-ethernet = " {bandwidthUpBits} |  {bandwidthDownBits}";
      format-alt = "<span font='12' rise='-2pt'>󰲐</span> {ipaddr}/{cidr}";
      format-linked = "󰖪 {ifname} (No IP)";
      format-disconnected = "󱛅 Disconnected";
      format-disabled = "󰖪 Disabled";
      tooltip-format = "󰀂 {ifname} via {gwaddr}";
      on-click-right = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
    };
    tray = {
      icon-size = 16;
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
    "hyprland/workspaces" = {
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
        # active = "";
        # default = "";
      };
      persistent-workspaces = {
        "DP-1" = [ 2 3 ];
        "DP-2" = [ 1 ];
      };
      on-scroll-down = "hyprctl dispatch workspace e-1";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      all-outputs = false;
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
