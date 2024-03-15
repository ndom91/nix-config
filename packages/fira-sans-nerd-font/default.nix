{ stdenvNoCC, fetchZip }:
stdenvNoCC.mkDerivation rec {
  name = "fira-sans-nerd-font";
  version = "1.0";
  src = fetchZip {
    url = "https://github.com/mozilla/Fira/archive/refs/tags/4.202.zip";
    sha256 = "116j26gdj5g1r124b4669372f7490vfjqw7apiwp2ggl0am5xd0w";
  };

  buildInputs = with pkgs; [ unzip parallel nerd-font-patcher ];

  setSourceRoot = "sourceRoot=`pwd`";

  unpackPhase = ''
    unzip $src

    mkdir -p fonts/{opentype,truetype}

    find Fira-4.202 -name \*.otf -exec mv {} fonts/opentype/ \;
    find Fira-4.202 -name \*.ttf -exec mv {} fonts/truetype/ \;
  '';

  buildPhase = ''
    find fonts/ -name \*.ttf -o -name \*.otf -print0 | parallel -j $NIX_BUILD_CORES -0 nerd-font-patcher -c {}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype}

    find fonts/opentype -name \*.otf -exec mv {} $out/share/fonts/opentype/ \;
    find fonts/truetype -name \*.ttf -exec mv {} $out/share/fonts/truetype/ \;

    runHook postInstall
  '';
}
