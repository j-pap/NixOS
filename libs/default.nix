{
  lib,
  ...
}:
{
  _module.args.extraLibs = {
    getExt = import ./get-file-ext.nix { inherit lib; };
    toFloat = import ./to-float.nix { inherit lib; };
    trimFloat = import ./trim-float.nix { inherit lib; };
  };
}
