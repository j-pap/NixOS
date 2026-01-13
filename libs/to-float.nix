let
  matchStripInput = builtins.match "[[:space:]]*0*(-?[[:digit:]]+)[[:space:]]*";
  matchZero = builtins.match "0+";
in
s:
let
  str = builtins.substring 0 4 s; # Reduces string down to two decimal places

  whole = builtins.fromJSON (builtins.elemAt (builtins.splitVersion str) 0);
  decStr = builtins.elemAt (builtins.splitVersion str) 1;

  decCheck = matchStripInput decStr;
  isZero = matchZero (builtins.head decCheck) == [ ];
  decParsed = builtins.fromJSON (builtins.head decCheck);

  decimal = if isZero then 0 else decParsed;
in
whole + (decimal / 100.0)
