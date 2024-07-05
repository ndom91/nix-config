{ stdenv, makeWrapper, fetchFromGitHub, lib, autoPatchelfHook, libmbim, libgcc, pciutils, openssl }:
stdenv.mkDerivation rec {
  name = "lenovo-wwan-unlock-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lenovo";
    repo = "lenovo-wwan-unlock";
    rev = "refs/tags/v${version}";
    hash = "sha256-6/V6ilLty1kX8lIPQ9B4LZJWG6Mn9r/CHJmkjigu7qI=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libmbim
    libgcc
    pciutils
    openssl
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/opt $out/bin

    ### Copy fcc unlock script for MM
    tar -vzxf fcc-unlock.d.tar.gz -C $out/lib/
    chmod ugo+x $out/lib/fcc-unlock.d/*

    ### Copy SAR config files
    tar -vzxf sar_config_files.tar.gz -C $out/opt/

    ### Copy libraries
    cp -rvf libmodemauth.so $out/lib/
    cp -rvf libconfigserviceR+.so $out/lib/
    cp -rvf libconfigservice350.so $out/lib/
    cp -rvf libmbimtools.so $out/lib/

    ### Copy binary
    cp -rvf DPR_Fcc_unlock_service $out/bin/
    cp -rvf configservice_lenovo $out/bin/

    ### Grant permissions to all binaries and script
    chmod ugo+x $out/opt/*
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/lenovo/lenovo-wwan-unlock";
    description = "FCC and DPR unlock for Lenovo PCs";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ "The Internet's Beloved Princess Grace" ];
  };
}
