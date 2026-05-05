{
  lib,
  buildFirefoxXpiAddon,
}:
let
  version = "4.3.6.0";
  commit = "e5323acc355ef8721cae8e22832b19feccc8bcb9";
  sha256 = "sha256-mJVbkBpXxIwGD8DuE8M32m0qxA1CDchEY6K+1E7L4aU=";
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
