{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
    # TODO: Fix SHA
    hash = lib.fakeSha256;
  };

  # cargoHash = lib.fakeHash;
  # cargoLock = {
  #   lockFile = ./Cargo.lock;
  # };
  # TODO: Fix SHA
  cargoSha256 = lib.fakeSha256;

  # Tests need the executable in target/debug/
  preCheck = ''
    cargo build
  '';

  meta = with lib; {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ samueltardieu ];
    mainProgram = "binsider";
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
}
