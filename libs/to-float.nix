let
  matchStripInput = builtins.match "[[:space:]]*0*(-?[[:digit:]]+)[[:space:]]*";
  matchZero = builtins.match "0+";

  strCheck = s: matchStripInput s;
  isZero = s: matchZero (builtins.head (strCheck s)) == [ ];
  strParsed = s: builtins.fromJSON (builtins.head (strCheck s));
in
str:
let
  wStr = builtins.elemAt (builtins.splitVersion str) 0;
  dStr = builtins.substring 0 2 (builtins.elemAt (builtins.splitVersion str) 1);

  whole = if (isZero wStr) then 0 else (strParsed wStr);
  decimal = if (isZero dStr) then 0 else (strParsed dStr);
in
whole + (decimal / 100.0)
