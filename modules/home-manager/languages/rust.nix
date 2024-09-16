{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    rustup
    # rustc
    # cargo
  ];
}
