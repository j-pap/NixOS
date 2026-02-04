{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  pname = "catppuccin-frappe.yazi";
  version = "unstable-2026-01-18";
  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "ca6165818bb84d46af5fd8f95bedd2b1c395890a";
    hash = "sha256-xGnebGuSOZpQl/QhuZkwgrjfAlfbEtruA9UVe030mZM=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  installPhase = ''
    runHook preInstall

    cp -r ${pname}/ $out/

    runHook postInstall
  '';

  meta = {
    description = "Catppuccin Frappe Flavor for Yazi";
    homepage = "https://github.com/yazi-rs/flavors";
    license = lib.licenses.mit;
  };
}
