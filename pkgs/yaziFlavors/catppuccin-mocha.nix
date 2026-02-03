{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  pname = "catppuccin-mocha";
  version = "unstable-2026-01-18";
  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "ca6165818bb84d46af5fd8f95bedd2b1c395890a";
    hash = "sha256-xGnebGuSOZpQl/QhuZkwgrjfAlfbEtruA9UVe030mZM=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp $src/${pname}.yazi/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Some Yazi flavors maintained by community";
    homepage = "https://github.com/yazi-rs/flavors";
  };
}
