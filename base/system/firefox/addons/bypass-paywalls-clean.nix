{
  lib,
  buildFirefoxXpiAddon,
}:
let
  version = "4.4.1.0";
  commit = "8b376624b9e8e1714d4cb5b7cf8e64300d5744ff";
  sha256 = "sha256-6V4RBK/eMFWhNxUj0nrJFYu0QQHj16aounfFqTx87rA=";
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
