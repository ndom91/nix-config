{ stdenv, lib, pkgs, ... }:
stdenv.mkDerivation rec {
  pname = "flameshot";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
    sha256 = "sha256-omyMN8d+g1uYsEw41KmpJCwOmVWLokEfbW19vIvG79w=";
  };

  # patches = [
  #   # https://github.com/flameshot-org/flameshot/pull/3166
  #   (fetchpatch {
  #     name = "10-fix-wayland.patch";
  #     url = "https://github.com/flameshot-org/flameshot/commit/5fea9144501f7024344d6f29c480b000b2dcd5a6.patch";
  #     sha256 = "sha256-SnjVbFMDKD070vR4vGYrwLw6scZAFaQA4b+MbI+0W9E=";
  #   })
  # ];

  # passthru = {
  #   updateScript = lib.nix-update-script { };
  # };

  nativeBuildInputs = with pkgs; [
    cmake
    libsForQt5.qt5.wrapQtAppsHook
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtsvg
  ];
  buildInputs = with pkgs; [
    libsForQt5.qt5.qtbase
  ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    mainProgram = "flameshot";
    maintainers = with maintainers; [ scode oxalica ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
