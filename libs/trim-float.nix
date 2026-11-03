#######################################
# Trim a float to the specified number of fractional digits
# Globals:
#   trunc: trims the unwanted digits from the result, a float
#   power: multiply 'n' by itself for 'e' number of times, an integer or float
# Arguments:
#   float: decimal to trim, a float
#   place: number of fractional digits to remain, an integer
# Returns:
#   1.123456 3 -> 1.123
#######################################
{
  lib,
}:
float: place:
let
  trunc = f: if (f < 0) then builtins.ceil f else builtins.floor f;
  power = n: e: builtins.foldl' builtins.mul 1 (builtins.genList (_: n) e);
in
assert lib.assertMsg (builtins.isFloat float)
  "A float is required as the first argument of this function.";
assert lib.assertMsg (builtins.isInt place)
  "An integer is required as the second argument of this function.";
trunc (float * (power 10 place)) / (power 10.0 place)
