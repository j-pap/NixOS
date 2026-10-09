{
  lib,
  buildFirefoxXpiAddon,
}:
let
  version = "4.4.5.0";
  commit = "a1ca3e6d640a0312e8104546ea2d7ae631d08432";
  sha256 = "sha256-9Do2kP9VEHwIydxy8y4W/Rg2QzaAXgviDjPmUJXLaM8=";
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
