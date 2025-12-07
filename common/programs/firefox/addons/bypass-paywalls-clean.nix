{
  lib,
  buildFirefoxXpiAddon
}:
let
  version = "4.2.5.5";
  sha256 = "sha256-8ckpW6OLvlb0NfhAnD15CATgYL9xumoLbuxXiDH3jPk=";
  commit = "05046a6bc70bf0dd5140bdc7331240659f1a6fbf";
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
