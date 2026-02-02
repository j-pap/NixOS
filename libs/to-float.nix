#######################################
# Convert a string to a float (trimmed to hundredths)
# Globals:
#   parse: convert string to int
#   w: left digits of dec's decimal point, a string
#   f: right digits of dec's decimal point, a string
#   whole: w converted, an integer
#   frac: f converted, an integer to a float
# Arguments:
#   dec: string to convert
# Returns:
#   "1.123456" -> 1.12
#######################################
let
  matchStripInput = builtins.match "[[:space:]]*0*(-?[[:digit:]]+)[[:space:]]*";
  matchZero = builtins.match "0+";

  check = s: matchStripInput s;
  isZero = s: matchZero (builtins.head (check s)) == [ ];
  parse = s: builtins.fromJSON (builtins.head (check s));
in
dec:
let
  w = builtins.elemAt (builtins.splitVersion dec) 0;
  f = builtins.substring 0 2 (builtins.elemAt (builtins.splitVersion dec) 1);
  whole = if (isZero w) then 0 else (parse w);
  frac = (if (isZero f) then 0 else (parse f)) / 100.0;
in
whole + frac
