{pkgs, input, ... }:
{
  home.packages = with pkgs; [
    nodejs_20
    fnm
  ];
}
