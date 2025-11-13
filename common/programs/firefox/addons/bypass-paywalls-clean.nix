{
  lib,
  buildFirefoxXpiAddon
}:
let
  version = "4.2.3.0";
  sha256 = "sha256-5IFIZQQKL8RQuj8C9OSKqyL5wCYcmOu3hEiTV26j1Dk=";
  commit = "7c32388c4edc272721a9c7932914245e9694c590";
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
