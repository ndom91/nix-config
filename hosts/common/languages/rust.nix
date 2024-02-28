{pkgs, input, ... }:
{
  home.packages = with pkgs; [
    rustup
    cargo
  ];
}
