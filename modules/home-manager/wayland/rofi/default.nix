{ pkgs, ... }: {
  # xdg.configFile."rofi/config.rasi".source = ./config.rasi;

  xdg.configFile."rofi/bin/launcher".text = ''
    #!/usr/bin/env bash
    rofi \
      -show drun \
      -modi run,drun,ssh \
      -scroll-method 0 \
      -drun-match-fields all \
      -drun-display-format "{name}" \
      -no-drun-show-actions \
      -terminal alacritty \
      -theme "$HOME"/.config/rofi/config/launcher.rasi
  '';
  xdg.configFile."rofi/bin/launcher".executable = true;

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      kb-row-up:                      "Up,Control+k,Shift+Tab,Shift+ISO_Left_Tab";
      kb-row-down:                    "Down,Control+j";
      kb-accept-entry:                "Return,KP_Enter";
      terminal:                       "alacritty";
      kb-remove-to-eol:               "Control+Shift+e";
      kb-mode-previous:               "Shift+Left,Control+Shift+Tab,Control+h";
      kb-remove-char-back:            "BackSpace";
    }
  '';

  xdg.configFile."rofi/config/launcher.rasi".text = ''
    configuration {
      show-icons:                     true;
      icon-theme:                   "WhiteSur";
      display-drun: 		            "";
      drun-display-format:            "{icon} {name}";
      disable-history:                false;
      click-to-exit: 		            true;
      location:                       0;
    }

    * {
        BG:    #11111Bff;
        BGA:   #b4befeff;
        FG:    #D9E0EEff;
        FGA:   #b4befeff;
        BDR:   #b4befeff;
        SEL:   #1E1E2Eff;
        UGT:   #F28FADff;
        IMG:   #b4befeff;
        OFF:   #575268ff;
        ON:    #ABE9B3ff;
        TRANS: #00000000;
    }

    * {
        font: "Geist Mono Light 12";
    }

    window {
    transparency:                   "real";
    background-color:               @BG;
    text-color:                     @FG;
    border:                         2px;
    border-color:                   @BDR;
    border-radius:                  5px;
    width:                          450px;
    anchor:                         center;
    x-offset:                       0;
    y-offset:                       -50;
    }

    prompt {
    enabled: 			            true;
    padding: 			            8px;
    background-color: 		        @BG;
    text-color: 		            @IMG;
    }

    textbox-prompt-colon {
      expand: 			            false;
      str: 			                "🔍";
      background-color:               @TRANS;
      text-color:                     @FG;
      padding:                  8px 0px 8px 8px;
      font:			                "Geist Mono Light 18";
    }

    entry {
      background-color:               @BG;
      text-color:                     @FG;
      placeholder-color:              @FG;
      expand:                         true;
      horizontal-align:               0;
      placeholder:                    "Search...";
      blink:                          true;
      border:                  	    0px 0px 2px 0px;
      border-color:                   @BDR;
      padding:                        8px;
    }

    inputbar {
      children: 		                [ textbox-prompt-colon, prompt, entry ];
      background-color:               @BG;
      text-color:                     @FG;
      expand:                         false;
      border:                  	    0px 0px 0px 0px;
      border-radius:                  0px;
      border-color:                   @BDR;
      margin:                         0px 0px 0px 0px;
      padding:                        0px;
      position:                       center;
    }

    case-indicator {
      background-color:               @BG;
      text-color:                     @FG;
      spacing:                        0;
    }


    listview {
      background-color:               @BG;
      columns:                        1;
      lines:			                7;
      spacing:                        4px;
      cycle:                          false;
      dynamic:                        true;
      layout:                         vertical;
    }

    mainbox {
    background-color:               @BG;
    children:                       [ inputbar, listview ];
    spacing:                        15px;
    padding:                        15px;
    }

    element {
      background-color:               @BG;
      text-color:                     @FG;
      orientation:                    horizontal;
      border-radius:                  4px;
      padding:                        6px 6px 6px 6px;
    }

    element-icon {
      background-color: 	            inherit;
      text-color:       		        inherit;
      horizontal-align:               0.5;
      vertical-align:                 0.5;
      size:                           24px;
      border:                         0px;
    }

    element-text {
      background-color: 		        inherit;
      text-color:       		        inherit;
      expand:                         true;
      horizontal-align:               0;
      vertical-align:                 0.5;
      margin:                         2px 0px 2px 2px;
    }

    element normal.urgent,
    element alternate.urgent {
      background-color:               @UGT;
      text-color:                     @FG;
      border-radius:                  9px;
    }

    element normal.active,
    element alternate.active {
      background-color:               @BGA;
      text-color:                     @FG;
    }

    element selected {
      background-color:               @BGA;
      text-color:                     @SEL;
      border:                  	    0px 0px 0px 0px;
      border-radius:                  10px;
      border-color:                   @BDR;
    }

    element selected.urgent {
      background-color:               @UGT;
      text-color:                     @FG;
    }

    element selected.active {
      background-color:               @BGA;
      color:                          @FG;
    }
  '';

  home.packages = with pkgs; [
    rofi-wayland
  ];

  # programs.rofi = {
  #   enable = true;
  #   package = pkgs.rofi-wayland;
  # };
}
