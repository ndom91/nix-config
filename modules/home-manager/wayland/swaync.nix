{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;
in
{
  # Example theme: https://github.com/ErikReider/SwayNotificationCenter/blob/main/data/style/style.scss

  home.file.".config/swaync/config.json".text = ''
    {
      "$schema": "/etc/xdg/swaync/configSchema.json",
      "positionX": "right",
      "positionY": "top",
      "control-center-margin-top": 10,
      "control-center-margin-bottom": 10,
      "control-center-margin-right": 10,
      "control-center-margin-left": 10,
      "notification-2fa-action": true,
      "notification-inline-replies": true,
      "notification-icon-size": 64,
      "notification-body-image-height": 100,
      "notification-body-image-width": 200,
      "timeout": 10,
      "timeout-low": 5,
      "timeout-critical": 0,
      "fit-to-screen": true,
      "control-center-width": 500,
      "control-center-height": 1200,
      "notification-window-width": 500,

      "keyboard-shortcuts": false,
      "image-visibility": "when-available",
      "transition-time": 200,
      "hide-on-clear": false,
      "hide-on-action": true,
      "script-fail-notify": true,
      "widgets": [
        "title",
        "volume",
        "dnd",
        "notifications"
      ],
      "widget-config": {
        "title": {
            "text": "Notification Center",
            "clear-all-button": true,
            "button-text": "󰆴 Clear All"
        },
        "dnd": {
            "text": "Do Not Disturb"
        },
        "label": {
            "max-lines": 1,
            "text": "Notification Center"
        },
        "volume": {
            "label": "󰕾"
        }
      }
    }
  '';

  home.file.".config/swaync/style.css".text = ''
    * {
      font-family: FiraSans Nerd Font;
    }

    /*
    top-level control-center-margin working now
    .control-center {
      margin-top: 10px;
      margin-right: 10px;
      margin-bottom: 20px;
    }*/

    .control-center-list:focus,
    .notification-group.collapsed:focus {
      outline: none;
    }

    .notification-group.collapsed:focus .notification-row .notification {
      transition: all 300ms ease-in-out;
      outline: none;
      border: none;
    }

    .notification-group.collapsed .notification-row .notification {
      background-color: #${palette.base02};
      outline: none;
      border: none;
    }

    .notification-group.collapsed .notification-row:not(:last-child) .notification-action,
    .notification-group.collapsed .notification-row:not(:last-child) .notification-default-action {
      opacity: 0;
    }

    .notification-group.collapsed:hover .notification-row:not(:only-child) .notification {
      background-color: #${palette.base02};
    }

    .notification-row {
      outline: none;
      margin: 10px;
      font-weight: 300;
      padding: 0;
      border: none;
      background: transparent;
      border-top-right-radius: 5px;
      border-top-left-radius: 5px;
      border-bottom-right-radius: 5px;
      border-bottom-left-radius: 5px;
    }

    .notification {
      background: transparent;
      box-shadow: none;
      outline: none;
      padding: 0;
      border-radius: 5px;
      border: 1px solid;
      border-color: #${palette.base01};
      margin: 0px;
    }

    .notification-background {
      background: transparent;
      border: none;
      outline: none;
    }

    .notification-default-action,
    .notification-content {
      background: #${palette.base01};
      outline: none;
      padding: 10px;
      font-weight: 300;
      border: none;
      box-shadow: none;
      border-top-right-radius: 5px;
      border-top-left-radius: 5px;
      border-bottom-right-radius: 5px;
      border-bottom-left-radius: 5px;
      margin: 0;
    }

    /* Broken */
    .notification:not(.notification-action) .notification-default-action,
    .notification:not(.notification-action) .notification-content {
      border-bottom-right-radius: 0px;
      border-bottom-left-radius: 0px;
    }


    .notification-row:hover .notification-default-action,
    .notification-row:hover .notification-content {
      border-top-right-radius: 5px;
      border-top-left-radius: 5px;
    }

    .notification:hover,
    .notification-background:hover,
    .notification-default-action:hover,
    .notification-content:hover {
      border-top-right-radius: 5px;
      border-top-left-radius: 5px;
    }

    .close-button {
      background: #${palette.base0D};
      color: #${palette.base00};
      text-shadow: none;
      padding: 0;
      border-radius: 5px;
      margin-top: 5px;
      margin-right: 5px;
    }

    .close-button:hover {
      box-shadow: none;
      background: #${palette.base08};
      transition: all 300ms ease-in-out;
      border: none;
    }

    .notification-action {
      border: none;
      outline: none;
      background: #${palette.base00};
      opacity: 0.9;
      transition: all 300ms ease-in-out;
    }

    .notification-action:hover {
      color: #${palette.base0D};
      background: #${palette.base01};
    }

    .notification-action:first-child {
      border-bottom-left-radius: 5px;
      border: none;
      border-image-width: 0;
      box-shadow: none;
    }

    .notification-action:last-child {
      border-bottom-right-radius: 5px;
      border: none;
      box-shadow: none;
    }
    
    .blank-window {
      /* Window behind control center and on all other monitors */
      background: transparent;
    }

    .floating-notifications {
      background: transparent;
    }

    .floating-notifications .notification {
      box-shadow: none;
    }

    .inline-reply {
      margin-top: 8px;
    }

    .inline-reply-entry {
      background: #${palette.base00};
      color: #${palette.base05};
      caret-color: #${palette.base05};
      border-radius: 5px;
    }

    .inline-reply-button {
      margin-left: 4px;
      background: #${palette.base00};
      border-radius: 5px;
      color: #${palette.base05};
    }

    .inline-reply-button:disabled {
      background: initial;
      color: #${palette.base03};
      border: none;
    }

    .inline-reply-button:hover {
      background: #${palette.base00};
    }

    .body-image {
      margin-top: 6px;
      background-color: #${palette.base05};
      border-radius: 5px;
    }

    .summary {
      font-size: 16px;
      font-weight: 400;
      background: transparent;
      color: #${palette.base06};
      text-shadow: none;
    }

    .time {
      font-size: 16px;
      font-weight: 400;
      background: transparent;
      color: #${palette.base05};
      text-shadow: none;
      margin-right: 18px;
    }

    .body {
      font-size: 15px;
      font-weight: 300;
      background: transparent;
      color: #${palette.base05};
      text-shadow: none;
    }

    .control-center {
      background: #${palette.base00};
      border: 1px solid #${palette.base01};
      box-shadow:
          0 3px 2px -2px #00000099,
          0 7px 5px -2px #00000099,
          0 12px 10px -2px #00000099,
          0 22px 18px -2px #00000099,
          0 41px 33px -2px #00000099,
          0 100px 80px -2px #00000099;
      border-radius: 5px;
    }

    .control-center-list {
      background: transparent;
    }

    .control-center-list-placeholder {
      opacity: .5;
    }

    .floating-notifications {
      background: transparent;
    }

    .blank-window {
      background: alpha(black, 0);
    }

    .widget-title {
      color: #${palette.base04};
      background: #${palette.base00};
      padding: 5px 10px;
      margin: 10px 10px 5px 10px;
      font-size: 1.5rem;
      letter-spacing: -1px;
      font-weight: 300;
      border-radius: 5px;
    }

    .widget-title>button {
      font-size: 1rem;
      color: #${palette.base05};
      text-shadow: none;
      background: #${palette.base00};
      letter-spacing: 0px;
      box-shadow: none;
      border-radius: 5px;
      transition: all 300ms ease-in-out;
    }

    .widget-title>button:hover {
      background: #${palette.base08};
      color: #${palette.base00};
    }

    .widget-dnd {
      background: #${palette.base00};
      padding: 5px 10px;
      margin: 10px 10px 5px 10px;
      border-radius: 5px;
      font-size: large;
      letter-spacing: -1px;
      font-weight: 300;
      color: #${palette.base04};
    }

    .widget-dnd>switch {
      border-radius: 5px;
      background: #${palette.base0D};
      transition: all 300ms ease-in-out;
    }

    .widget-dnd>switch:checked {
      background: #${palette.base08};
      border: 1px solid #${palette.base08};
    }

    .widget-dnd>switch slider {
      background: #${palette.base00};
      border-radius: 5px;
    }

    .widget-dnd>switch:checked slider {
      background: #${palette.base00};
      border-radius: 5px;
    }

    .widget-label {
      margin: 10px 10px 5px 10px;
    }

    .widget-label>label {
      font-size: 1rem;
      color: #${palette.base05};
    }

    .widget-buttons-grid {
      font-size: x-large;
      padding: 5px;
      margin: 10px 10px 5px 10px;
      border-radius: 5px;
      background: #${palette.base01};
    }

    .widget-buttons-grid>flowbox>flowboxchild>button {
      margin: 3px;
      background: #${palette.base00};
      border-radius: 5px;
      color: #${palette.base05};
    }

    .widget-buttons-grid>flowbox>flowboxchild>button:hover {
      background: rgba(122, 162, 247, 1);
      color: #${palette.base00};
    }

    .widget-menubar>box>.menu-button-bar>button {
      border: none;
      background: transparent;
    }

    .topbar-buttons>button {
      border: none;
      background: transparent;
    }

    .widget-volume {
      background: #${palette.base01};
      padding: 5px;
      margin: 10px 10px 5px 10px;
      border-radius: 5px;
      font-size: x-large;
      color: #${palette.base05};
    }

    .widget-volume>box>button {
      background: #${palette.base0B};
      border: none;
    }

    .per-app-volume {
      background-color: #${palette.base00};
      padding: 4px 8px 8px;
      margin: 0 8px 8px;
      border-radius: 5px;
    }

    .widget-backlight {
      background: #${palette.base01};
      padding: 5px;
      margin: 10px 10px 5px 10px;
      border-radius: 5px;
      font-size: x-large;
      color: #${palette.base05};
    }
  '';
}
