{ input, unstablePkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    package = unstablePkgs.alacritty;
    settings = {
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

      key_bindings = [
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
      colors = {
        # transparent_background_colors = true;
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#11111B"; # base
          foreground = "#CDD6F4"; # text
          # Bright and dim foreground colors
          dim_foreground = "#CDD6F4"; # text
          bright_foreground = "#CDD6F4"; # text
        };

        # Cursor colors
        cursor = {
          text = "#11111B"; # base
          cursor = "#CDD6F4"; # text
        };
        vi_mode_cursor = {
          text = "#11111B"; # base
          cursor = "#B4BEFE"; # lavender
        };

        # Search colors
        search = {
          matches = {
            foreground = "#11111B"; # base
            background = "#A6ADC8"; # subtext0
          };
          focused_match = {
            foreground = "#11111B"; # base
            # background = "#A6E3A1"; # green
            background = "#F5C2E7"; # pink
          };
          footer_bar = {
            foreground = "#11111B"; # base
            background = "#A6ADC8"; # subtext0
          };
        };

        # Keyboard regex hints
        hints = {
          start = {
            foreground = "#11111B"; # base
            background = "#F9E2AF"; # yellow
          };
          end = {
            foreground = "#11111B"; # base
            background = "#A6ADC8"; # subtext0
          };
        };

        # Selection colors
        selection = {
          text = "#11111B"; # base
          background = "#F5E0DC"; # rosewater
        };

        # Normal colors
        normal = {
          black = "#45475A"; # surface1
          red = "#F38BA8"; # red
          green = "#286983"; # pine
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#BAC2DE"; # subtext1
        };

        # Bright colors
        bright = {
          black = "#585B70"; # surface2
          red = "#F38BA8"; # red
          green = "#3e8fb0"; # pine
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#A6ADC8"; # subtext0
        };

        # Dim colors
        dim = {
          black = "#45475A"; # surface1
          red = "#F38BA8"; # red
          green = "#31748f"; # pine
          yellow = "#F9E2AF"; # yellow
          blue = "#89B4FA"; # blue
          magenta = "#F5C2E7"; # pink
          cyan = "#94E2D5"; # teal
          white = "#BAC2DE"; # subtext1
        };
      };
    };
  };
}
