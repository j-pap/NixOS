{
  lib,
  buildFirefoxXpiAddon
}:
let
  commit = "0aa5c144fb18ad652a3e609dccf1642661f8a3ea";
  sha256 = "sha256-hMMo27lBbVH5Buq3mIwXFIZPDaVUrvKygLctRpAElFc=";
  version = "4.2.0.0";
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
