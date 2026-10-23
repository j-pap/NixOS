final: prev:
let
  yaziPath = ../pkgs/yaziFlavors;
in
{
  yaziFlavors = final.lib.pipe yaziPath [
    builtins.readDir
    (final.lib.filterAttrs (_: type: type == "directory"))
    (builtins.mapAttrs (flavor: _: prev.callPackage (yaziPath + /${flavor}) { }))
  ];
}
