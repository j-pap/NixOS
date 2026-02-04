{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
let
  pname = "pragmasevka";
  version = "1.6.6";
  src = fetchurl {
    url = "https://github.com/shytikov/pragmasevka/releases/download/v${version}/Pragmasevka.zip";
    hash = "sha256-7Re4ZEr6GYOKE3GG+F36M4vaKbuOZasNYLM6jY6LvgE=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;
  dontUnpack = true;
  nativeBuildInputs = [ unzip ];
  installPhase = ''
    unzip ${src}
    mkdir -p $out/share/fonts/truetype
    install --mode=644 ./*.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Pragmata Pro doppelgänger made of Iosevka SS08";
    homepage = "https://github.com/shytikov/pragmasevka";
  };
}
