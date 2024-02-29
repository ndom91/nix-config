{ pkgs, input, ... }:
{
  home.packages = with pkgs; [
    python311Full
  ];
}
