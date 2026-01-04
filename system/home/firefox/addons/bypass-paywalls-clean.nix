{
  lib,
  buildFirefoxXpiAddon,
}:
let
  version = "4.2.6.6";
  sha256 = "sha256-WrrL2ByH6Dj+ABl2NQWEVto/mvvFhoDUsVhwHHixoJA=";
  commit = "ae1bc7a239e5cb2b9297dc1d827f587b026f67e5";
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
