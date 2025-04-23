{
  lib,
  buildFirefoxXpiAddon
}:
let
  commit = "41b66a006d8e78cc5abb159fc558531f441097ea";
  sha256 = "sha256-VIcHif8gA+11oL5AsADaHA6qfWT8+S0A8msaYE2ivns=";
  version = "4.1.0.0";
in
buildFirefoxXpiAddon {
  pname = "bypass-paywalls-clean";
  inherit version;

  addonId = "magnolia@12.34";
  url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi&inline=false&commit=${commit}";
  sha256 = sha256;

  meta = {
    homepage = "https://twitter.com/Magnolia1234B";
    description = "Bypass Paywalls of (custom) news sites";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
