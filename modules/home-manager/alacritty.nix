{ input, unstablePkgs, ... }:
{

  programs.alacritty = {
    enable = true;
    package = unstablePkgs.alacritty;
    settings = {
      import = [
        /home/ndo/.config/alacritty-rose-pine.toml
      ];
      font = {
        size = 10;
        bold_italic = {
          family = "Operator Mono";
          style = "Bold Italic";
        };
        italic = {
          family = "Operator Mono";
          style = "Light Italic";
        };
        bold = {
          family = "Operator Mono";
          style = "Regular Bold";
        };
        normal = {
          family = "Operator Mono";
          style = "Light";
        };
      };

      # hints = {
      # enabled = [{
      # regex = ''
      #   (ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://\)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+
      # '';
      # hyperlinks = true;
      #     post_processing = true;
      #     mouse = {
      #       enabled = true;
      #       mods = "None";
      #     };
      #     binding = {
      #       key = "U";
      #       mods = "Control|Shift";
      #     };
      #   }];
      # };

      live_config_reload = true;

      env = {
        TERM = "alacritty";
      };

      scrolling = {
        history = 100000;
      };

      selection = {
        save_to_clipboard = true;
      };

      keyboard = {
        bindings = [
          {
            action = "Paste";
            key = "V";
            mods = "Control|Shift";
          }
          {
            action = "Copy";
            key = "C";
            mods = "Control|Shift";
          }
        ];
      };
      shell = {
        program = "bash";
        args = [ "-l" "-c" "tmux new-session" ];
      };
      window = {
        dynamic_title = true;
        opacity = 0.8;
        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
        padding = {
          x = 0;
          y = 0;
        };
      };
      # colors = {
      #   draw_bold_text_with_bright_colors = true;
      #   # primary = {
      #     # background = "#11111B";
      #     # foreground = "#e0def4";
      #
      #     # Bright and dim foreground colors
      #     # dim_foreground = "#e0def4";
      #     # bright_foreground = "#e0def4";
      #     # };
      #
      #   # Cursor colors
      #   cursor = {
      #     text = "#21202e";
      #     cursor = "#e0def4";
      #   };
      #   vi_mode_cursor = {
      #     text = "#21202e";
      #     cursor = "#908caa";
      #   };
      #
      #   # Search colors
      #   search = {
      #     matches = {
      #       foreground = "#21202e";
      #       background = "#908caa";
      #     };
      #     focused_match = {
      #       foreground = "#21202e";
      #       # background = "#9ccfd8";
      #       background = "#F38BA8";
      #     };
      #     # footer_bar = {
      #     #   foreground = "#191724";
      #     #   background = "#908caa";
      #     # };
      #   };
      #
      #   # Keyboard regex hints
      #   hints = {
      #     start = {
      #       foreground = "#21202e";
      #       background = "#f6c177";
      #     };
      #     end = {
      #       foreground = "#21202e";
      #       background = "#908caa";
      #     };
      #   };
      #
      #   # Selection colors
      #   selection = {
      #     text = "#21202e";
      #     background = "#ebbcba";
      #   };
      #
      #   # Normal colors
      #   # Rose Pine - https://rosepinetheme.com/palette/ingredients/
      #   normal = {
      #     black = "#191724"; # Base
      #     red = "#F38BA8"; # Love
      #     green = "#31748f"; # Pine
      #     yellow = "#f6c177"; # Gold
      #     blue = "#6e6a86"; # Muted
      #     magenta = "#c4a7e7"; # Iris
      #     cyan = "#9ccfd8"; # Foam
      #     white = "#e0def4"; # Text
      #   };
      #
      #   # Bright colors
      #   # Rose Pine Moon - https://rosepinetheme.com/palette/ingredients/
      #   bright = {
      #     black = "#232136"; # Base
      #     red = "#eb6f92"; # Love
      #     green = "#3e8fb0"; # Pine
      #     yellow = "#f6c177"; # Gold
      #     blue = "#6e6a86"; # Muted
      #     magenta = "#c4a7e7"; # Iris
      #     cyan = "#9ccfd8"; # Foam
      #     white = "#e0def4"; # Text
      #   };
      #
      #   # Dim colors
      #   # dim = {
      #   #   black = "#45475A";
      #   #   red = "#F38BA8";
      #   #   green = "#31748f";
      #   #   yellow = "#F9E2AF";
      #   #   blue = "#89B4FA";
      #   #   magenta = "#F5C2E7";
      #   #   cyan = "#94E2D5";
      #   #   white = "#BAC2DE";
      #   # };
      # };
    };
  };
}
