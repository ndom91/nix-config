{ config, pkgs, ... }:
{
  programs.swaylock = {
    enable = false;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      show-failed-attempts = true;
      screenshots = true;
      clock = true;
      effect-scale = "0.75";
      effect-pixelate = "10";
      color = "1f1d2e80";
      font = "Fira Sans Nerd Font";
      grace = "0";
      datestr = "%d.%m.%y";
      fade-in = "1";
      ignore-empty-password = true;
      indicator = true;
      indicator-idle-visible = true;
      indicator-radius = "200";
      indicator-thickness = "20";
      line-color = "21202e00";
      ring-color = "907aa9";
      inside-color = "191724";
      key-hl-color = "f6c177";
      separator-color = "21202e00";
      text-color = "e0def4";
      text-caps-lock-color = "";
      line-ver-color = "ebbcba";
      ring-ver-color = "ebbcba";
      inside-ver-color = "1f1d2e";
      text-ver-color = "e0def4";
      ring-wrong-color = "31748f";
      text-wrong-color = "31748f";
      inside-wrong-color = "1f1d2e";
      inside-clear-color = "1f1d2e";
      text-clear-color = "e0def4";
      ring-clear-color = "9ccfd8";
      line-clear-color = "1f1d2e";
      line-wrong-color = "1f1d2e";
      bs-hl-color = "31748f";
    };
  };
}
