{
  lib,
  buildFirefoxXpiAddon,
}:
let
  version = "4.2.8.0";
  sha256 = "sha256-qKyeJaq/lDRF1fg124iEzMbpyu6isogk9jOed54yzws=";
  commit = "ddfc2dd1a17f937c0f7cf970183ecb67c13aa4df";
in
buildFirefoxXpiAddon {
  pname = "bypass-paywalls-clean";
  inherit version;

  addonId = "magnolia@12.34";
  url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi&inline=false&commit=${commit}";
  inherit sha256;

  meta = {
    homepage = "https://twitter.com/Magnolia1234B";
    description = "Bypass Paywalls of (custom) news sites";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
