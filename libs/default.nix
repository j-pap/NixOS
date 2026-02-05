{
  lib,
  ...
}:
{
  _module.args.extraLibs = {
    toFloat = import ./to-float.nix { inherit lib; };
    truncateFloat = import ./truncate-float.nix;
  };
}
