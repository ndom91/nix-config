{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    # rustc
    # cargo
    rustup

    # for building gitbutler
    libsoup
  ];
}
