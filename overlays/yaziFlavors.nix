final: prev:
let
  root = ../pkgs/yaziFlavors;
in
{
  yaziFlavors = final.lib.pipe root [
    builtins.readDir
    (final.lib.filterAttrs (_: type: type == "directory"))
    (builtins.mapAttrs (name: _: prev.callPackage (root + /${name}) { }))
  ];
}
