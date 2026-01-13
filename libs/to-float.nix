s:
let
  whole = builtins.fromJSON (builtins.elemAt (builtins.splitVersion s) 0);
  decimal = (builtins.fromJSON (builtins.elemAt (builtins.splitVersion s) 1)) / 100.0;
in
whole + decimal
