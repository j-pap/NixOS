#######################################
# Trim a float to the specified number of places
# Globals:
#   trunc: trims the unwanted digits from the result, a float
#   power: multiply 'n' by itself for 'e' number of times, an integer or float
# Arguments:
#   float: decimal to trim, a float
#   place: number of digits to remain, an integer
# Returns:
#   1.123456 3 -> 1.123
#######################################
float: place:
let
  trunc = f: if (f < 0) then builtins.ceil f else builtins.floor f;
  power = n: e: builtins.foldl' builtins.mul 1 (builtins.genList (_: n) e);
in
trunc (float * (power 10 place)) / (power 10.0 place)
