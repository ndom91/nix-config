{ unstablePkgs, pkgs, input, ... }:
{
  home.packages = with unstablePkgs; [
    rustup
    # clang_18
    # rustc
    # cargo
  ];

  home.file.".cargo/config.toml" = {
    force = true;
    source = ../../../dotfiles/programming/cargo/config.toml;
  };
}
