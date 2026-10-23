{
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pragmasevka";
  version = "1.6.6";
  src = fetchurl {
    url = "https://github.com/shytikov/pragmasevka/releases/download/v${finalAttrs.version}/Pragmasevka.zip";
    hash = "sha256-7Re4ZEr6GYOKE3GG+F36M4vaKbuOZasNYLM6jY6LvgE=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ unzip ];
  installPhase = ''
    runHook preInstall

    unzip ${finalAttrs.src}
    mkdir -p $out/share/fonts/truetype
    install --mode=644 ./*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Pragmata Pro doppelgänger made of Iosevka SS08";
    homepage = "https://github.com/shytikov/pragmasevka";
  };
})
