final: prev:
let
  getNixVer =
    v:
    final.lib.concatStringsSep "_" [
      "${final.lib.versions.major v}"
      "${final.lib.versions.minor v}"
    ];
in
{
  nix-plugins = prev.nix-plugins.override {
    nixComponents = final.nixVersions."nixComponents_${getNixVer final.nix.version}";
  };
}
