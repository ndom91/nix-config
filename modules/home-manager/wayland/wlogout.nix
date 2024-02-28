{ pkgs, ... }:
{
  xdg.configFile."wlogout" = {
    source = ../../../dotfiles/wlogout/icons;
    recursive = true;
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "lock";
        "action" = "swaylock";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "reboot";
        "action" = "systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
      {
        "label" = "shutdown";
        "action" = "systemctl poweroff";
        "text" = "Shutdown";
        "keybind" = "s";
      }
      {
        "label" = "logout";
        "action" = "hyprctl dispatch exit 0";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "suspend";
        "action" = "systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
    ];
    style = ''
      window {
          font-family: monospace;
          font-size: 14pt;
          color: #cdd6f4; /* text */
          background-color: rgba(30, 30, 46, 0.5);
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border: none;
          background-color: rgba(30, 30, 46, 0);
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
          background-color: rgba(49, 50, 68, 0.1);
      }

      button:focus {
          background-color: #cba6f7;
          color: #1e1e2e;
      }

      #lock {
          background-image: image(url("./icons/lock.png"));
      }
      #lock:focus {
          background-image: image(url("./icons/lock-hover.png"));
      }

      #logout {
          background-image: image(url("./icons/logout.png"));
      }
      #logout:focus {
          background-image: image(url("./icons/logout-hover.png"));
      }

      #suspend {
          background-image: image(url("./icons/sleep.png"));
      }
      #suspend:focus {
          background-image: image(url("./icons/sleep-hover.png"));
      }

      #shutdown {
          background-image: image(url("./icons/power.png"));
      }
      #shutdown:focus {
          background-image: image(url("./icons/power-hover.png"));
      }

      #reboot {
          background-image: image(url("./icons/restart.png"));
      }
      #reboot:focus {
          background-image: image(url("./icons/restart-hover.png"));
      }
    '';
  };
}
