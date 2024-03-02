{ lib, qtbase, qtsvg, qtgraphicaleffects, qtquickcontrols2, wrapQtAppsHook, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  name = "corners";
  version = "1.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "czw";
    repo = "sddm-theme-corners";
    rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    sha256 = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
  };
  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedUserEnvPkgs = [ qtbase qtsvg qtgraphicaleffects qtquickcontrols2 ];

  installPhase = '' 
    mkdir -p $out/share/sddm/themes 
    cp -aR $src $out/share/sddm/themes/corners
  '';
}
