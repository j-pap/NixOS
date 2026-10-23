{
  stdenv,
  fetchurl,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iosvmata";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/N-R-K/Iosvmata/releases/download/v${finalAttrs.version}/Iosvmata-v${finalAttrs.version}.tar.zst";
    hash = "sha256-Cq/bx+nc5sTHxb4GerpEHDmW7st835bQ6ihTOp20Ei4=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ zstd ];
  installPhase = ''
    runHook preInstall

    tar xvf ${finalAttrs.src}
    mkdir -p $out/share/fonts/truetype
    install --mode=644 ./Iosvmata-v${finalAttrs.version}/Normal/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Custom Iosevka build somewhat mimicking PragmataPro";
    homepage = "https://github.com/N-R-K/Iosvmata";
  };
})
