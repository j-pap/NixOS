{
  lib,
  buildFirefoxXpiAddon,
}:
let
  version = "4.2.9.0";
  sha256 = "sha256-5JXHGIaNYnG7Sqqh20EZECJ6x+63fqJzA5TGCc95kdE=";
  commit = "36dd97bc02181c14ffe8dcb5941862b534d6527e";
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
