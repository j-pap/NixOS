{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
}:
let
  pname = "cosmic-ext-color-picker";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "PixelDoted";
    repo = pname;
    tag = version;
    hash = "sha256-8joPqbnCPUwguRUXz8Dhzpv9j0mFCh004leQwMruQ60=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-XfAqBOgiZZCxWmU1Rj4sUr8M9WFDxbQc5PmdFHgOIB4=";

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-05-20";
    VERGEN_GIT_SHA = src.tag;
  };

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  postPatch = ''
    mv res/app.desktop res/io.github.pixeldoted.${pname}.desktop
    mv res/metainfo.xml res/io.github.pixeldoted.${pname}.metainfo.xml
  '';

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/${pname}"
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  meta = {
    description = "A Color Picker for the COSMIC™ desktop";
    homepage = "https://github.com/PixelDoted/cosmic-ext-color-picker";
    license = lib.licenses.gpl3;
  };
}
