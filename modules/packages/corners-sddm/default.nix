{ lib, qtbase, qtsvg, qtgraphicaleffects, qtquickcontrols2, wrapQtAppsHook, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  name = "corners";
  version = "1.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "aczw";
    repo = "sddm-theme-corners";
    rev = "6ff0ff455261badcae36cd7d151a34479f157a3c";
    sha256 = "sha256-CPK3kbc8lroPU8MAeNP8JSStzDCKCvAHhj6yQ1fWKkY=";
  };
  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedUserEnvPkgs = [ qtbase qtsvg qtgraphicaleffects qtquickcontrols2 ];

  installPhase = '' 
    mkdir -p $out/share/sddm/themes 
    cp -aR $src $out/share/sddm/themes/corners
  '';
}
