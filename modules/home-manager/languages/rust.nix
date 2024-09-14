{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    rustc
    rustup
    cargo

    # for building gitbutler
    libsoup
  ];
}
