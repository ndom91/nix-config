{ lib, stdenv, pkgs, unstablePkgs, ... }:
let
  python = pkgs.python3.withPackages (pp: [ pp.pygobject3 ]);
  lua = pkgs.luajit.withPackages (ps: [ ps.lgi ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "2.99.18";

  outputs = [ "out" "dev" ];

  src = pkgs.fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${
        lib.versions.majorMinor finalAttrs.version
      }/gimp-${finalAttrs.version}.tar.xz";
    hash = "sha256-jBu3qUrA1NDN5NcB2LNWOHwuzYervTW799Ii1A9t224=";
  };

  patches = [ ./meson-gtls.patch ./pygimp-interp.patch ];

  nativeBuildInputs = with pkgs; [
    aalib
    alsa-lib
    appstream
    bashInteractive
    # cmake
    findutils
    ghostscript
    gi-docgen
    isocodes
    libarchive
    libheif
    libjxl
    libmng
    libwebp
    libxslt
    meson
    ninja
    perl538
    pkg-config
    unstablePkgs.gegl
    vala
    wrapGAppsHook
    xvfb-run
  ];

  buildInputs = with pkgs; [
    aalib
    appstream-glib
    babl
    cairo
    cfitsio
    desktop-file-utils
    gdk-pixbuf
    gexiv2
    ghostscript
    gjs
    glib
    glib-networking
    gobject-introspection
    gtk3
    lcms
    libgudev
    libheif
    libjxl
    libmng
    libmypaint
    librsvg
    libwebp
    libwmf
    lua
    mypaint-brushes1
    openexr
    poppler
    poppler_data
    python
    qoi
    shared-mime-info
    unstablePkgs.gegl
    xorg.libXmu
    xorg.libXpm
  ];

  preConfigure =
    "patchShebangs tools/gimp-mkenums app/tests/create_test_env.sh plug-ins/script-fu/scripts/ts-helloworld.scm";

  mesonFlags = [ "-Dilbm=disabled" ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = with lib; {
    description = "The GNU Image Manipulation Program: Development Edition";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ "9p4" ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "gimp";
  };
})
