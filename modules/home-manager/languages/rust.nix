{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    # rustc
    # cargo
    rustup
    # rustc
    # cargo
  ];
}
