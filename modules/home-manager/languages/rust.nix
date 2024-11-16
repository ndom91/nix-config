{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    rustup
    # rustc
    # cargo
  ];

  home.file.".cargo/config.toml" = {
    force = true;
    source = ../../../dotfiles/programming/cargo/config.toml;
  };
}
