{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  librsvg,
  xcursorgen,
  variant ? "Bibata-Modern-Classic",
}:
let
  pname = "bibata-hyprcursor";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "rtgiskard";
    repo = "bibata_cursor";
    tag = "v${version}";
    hash = "sha256-p36pHyoVOcDPm/tbk8YKsL+ItTaVKrGTfQ8zp022mGA=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  postPatch = "patchShebangs ./src/cursor_utils.py";

  nativeBuildInputs = [
    python3
    #librsvg # x11
    #xcursorgen # x11
  ];

  buildPhase = ''
    runHook preBuild

    # --hypr supports Hyprland; --x11 supports XCursor
    # --theme builds a specific theme rather than the default Moderns: Classic, Ice, & Amber
    ./src/cursor_utils.py --hypr --theme ${variant} --out-dir ./out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ./out/Bibata-* $out/share/icons/

    runHook postInstall
  '';

  meta = {
    description = "Bibata Cursor, with support for hyprcursor and Xcursor";
    homepage = "https://github.com/rtgiskard/bibata_cursor";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
