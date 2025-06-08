{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    go
    gopls
    gotools
    go-tools
  ];
}
