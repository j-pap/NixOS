#######################################
# Convert a string to a float (trimmed to hundredths)
# Globals:
#   numPart: a function that returns the respective numeral part, accepts 0 or 1
#   int: pass the integral to numPart, a function passing 0
#   frac: pass the fractional to numPart, a function passing 1
#   integral: integral digits, an integer
#   fractional: fractional digits trimmed, a float
# Arguments:
#   dec: float to convert, a string
# Returns:
#   "1.123456" -> 1.12
#######################################
{
  lib,
}:
dec:
let
  numPart = n: builtins.elemAt (lib.splitString "." dec) n;
  int = numPart 0;
  frac = numPart 1;
  integral = lib.toIntBase10 (if (int == "") then "0" else int);
  fractional =
    lib.toIntBase10 (
      builtins.substring 0 2 (
        if (int == "") then
          if (lib.stringLength frac == 1) then (frac + "0") else frac
        else if ((lib.length (builtins.splitVersion dec)) < 2) then
          "00"
        else if (lib.stringLength frac == 1) then
          (frac + "0")
        else
          frac
      )
    )
    / 100.0;
in
assert lib.assertMsg (builtins.isString dec)
  "A string-wrapped float is required to use this function.";
assert lib.assertMsg (
  (lib.length (builtins.splitVersion dec)) >= 1
) "That is an unsupported float.";
integral + fractional
