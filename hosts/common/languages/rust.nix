{pkgs, input, ... }:
{
  home.packages = with pkgs; [
    rustc
    cargo
  ];
}
