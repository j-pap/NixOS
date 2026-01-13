{
  _module.args.extraLibs = {
    toFloat = import ./to-float.nix;
    truncateFloat = import ./truncate-float.nix;
  };
}
