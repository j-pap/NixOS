{
  lib,
  ...
}:
{
  _module.args.extraLibs = {
    getExtension = import ./get-file-ext.nix { inherit lib; };
    toFloat = import ./to-float.nix { inherit lib; };
    truncateFloat = import ./truncate-float.nix;
  };
}
