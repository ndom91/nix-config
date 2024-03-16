{ fetchzip, pkgs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  name = "fira-sans-nerd-font";
  version = "1.0";
  src = fetchzip {
    url = "https://github.com/mozilla/Fira/archive/refs/tags/4.202.zip";
    sha256 = "116j26gdj5g1r124b4669372f7490vfjqw7apiwp2ggl0am5xd0w";
  };

  buildInputs = with pkgs; [ parallel nerd-font-patcher ];

  buildPhase = ''
    find -name \*.ttf -o -name \*.otf -print0 | parallel -j $NIX_BUILD_CORES -0 nerd-font-patcher --makegroups 2 -c {}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/fonts/truetype

    find -name \*.otf -maxdepth 1 -exec mv {} $out/share/fonts/opentype/ \;
    find -name \*.ttf -maxdepth 1 -exec mv {} $out/share/fonts/truetype/ \;

    runHook postInstall
  '';
}
