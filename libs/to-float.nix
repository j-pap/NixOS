#######################################
# Convert a string to a float (trimmed to hundredths)
# Globals:
#   w: left digits of dec's decimal point, a string
#   f: right digits of dec's decimal point, a string
#   whole: w converted, an integer
#   frac: f converted, an integer to a float
# Arguments:
#   dec: string to convert
# Returns:
#   "1.123456" -> 1.12
#######################################
{
  lib,
}:
dec:
let
  w = lib.versions.major dec;
  f = builtins.substring 0 2 (lib.versions.minor dec);
  whole = lib.toIntBase10 w;
  frac = (lib.toIntBase10 f) / 100.0;
in
whole + frac
