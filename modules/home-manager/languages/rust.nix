{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    rustc
    cargo

    # for building gitbutler
    libsoup
  ];
}
