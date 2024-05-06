{ pkgs, config, ... }:
{
  xdg.configFile."wlogout" = {
    source = ../../../dotfiles/wlogout;
    recursive = true;
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "lock";
        "action" = "${config.programs.swaylock.package}/bin/swaylock";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "reboot";
        "action" = "${pkgs.systemd}/bin/systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
      {
        "label" = "shutdown";
        "action" = "${pkgs.systemd}/bin/systemctl poweroff";
        "text" = "Shutdown";
        "keybind" = "s";
      }
      {
        "label" = "logout";
        "action" = "${pkgs.hyprland}/bin/hyprctl dispatch exit 0";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "suspend";
        "action" = "${pkgs.systemd}/bin/systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
    ];
    # style = ''
    #   window {
    #       font-family: monospace;
    #       font-size: 14pt;
    #       color: #cdd6f4; /* text */
    #       background-color: rgba(30, 30, 46, 0.5);
    #   }
    #
    #   button {
    #       background-repeat: no-repeat;
    #       background-position: center;
    #       background-size: 25%;
    #       border: none;
    #       background-color: rgba(30, 30, 46, 0);
    #       margin: 5px;
    #       transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
    #   }
    #
    #   button:hover {
    #       background-color: rgba(49, 50, 68, 0.1);
    #   }
    #
    #   button:focus {
    #       background-color: #cba6f7;
    #       color: #1e1e2e;
    #   }
    #
    #   #lock {
    #       background-image: image(url("./icons/lock.png"));
    #   }
    #   #lock:focus {
    #       background-image: image(url("./icons/lock-hover.png"));
    #   }
    #
    #   #logout {
    #       background-image: image(url("./icons/logout.png"));
    #   }
    #   #logout:focus {
    #       background-image: image(url("./icons/logout-hover.png"));
    #   }
    #
    #   #suspend {
    #       background-image: image(url("./icons/sleep.png"));
    #   }
    #   #suspend:focus {
    #       background-image: image(url("./icons/sleep-hover.png"));
    #   }
    #
    #   #shutdown {
    #       background-image: image(url("./icons/power.png"));
    #   }
    #   #shutdown:focus {
    #       background-image: image(url("./icons/power-hover.png"));
    #   }
    #
    #   #reboot {
    #       background-image: image(url("./icons/restart.png"));
    #   }
    #   #reboot:focus {
    #       background-image: image(url("./icons/restart-hover.png"));
    #   }
    # '';
    # Style from 'hyprdots': https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_1.png
    # https://github.com/prasanthrangan/hyprdots/blob/main/Configs/.config/wlogout/style_1.css
    # https://github.com/prasanthrangan/hyprdots/blob/37da06d3867671134186581453a7da00ea520a4b/Configs/.local/share/bin/logoutlaunch.sh#L63
    style = ''
      * {
          background-image: none;
          font-size: 32px;
      }

      window {
          background-color: transparent;
          padding: 128px;
      }

      button {
          color: white;
          background-color: #11111b;
          outline-style: none;
          border: none;
          border-width: 0px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          border-radius: 8px;
          box-shadow: none;
          text-shadow: none;
          animation: gradient_f 20s ease-in infinite;
          margin : 256px 0px 256px 0px;
      }

      button:focus {
          background-color: #a6adc8;
          background-size: 30%;
      }

      button:hover {
          color: black;
          background-color: #f5c2e7;
          background-size: 40%;
          opacity: 0.9;
          border-radius: 16px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
          margin : 190px 0px 190px 0px;
      }

      #lock {
          background-image: image(url("./icons/lock.png"));
          margin-left: 256px;
      }
      #lock:hover {
          background-image: image(url("./icons/lock-hover.png"));
      }

      #logout {
          background-image: image(url("./icons/logout.png"));
      }
      #logout:hover {
          background-image: image(url("./icons/logout-hover.png"));
      }

      #suspend {
          background-image: image(url("./icons/sleep.png"));
          margin-right: 256px;
      }
      #suspend:hover {
          background-image: image(url("./icons/sleep-hover.png"));
      }

      #shutdown {
          background-image: image(url("./icons/power.png"));
      }
      #shutdown:hover {
          background-image: image(url("./icons/power-hover.png"));
      }

      #reboot {
          background-image: image(url("./icons/restart.png"));
      }
      #reboot:hover {
          background-image: image(url("./icons/restart-hover.png"));
      }
    '';
  };
}
