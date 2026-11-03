#######################################
# Retrieve a filename's extension
# Globals:
#   names: filename split by ".", a list of strings
#   ext: count of names list, minus one, an integer
# Arguments:
#   file: filename to get extension from, a string
# Returns:
#   "file.ext" -> "ext"
#######################################
{
  lib,
}:
file:
let
  names = lib.splitString "." (builtins.baseNameOf file); # "path/to/file.ext" -> [ "file" "ext" ]
  ext = (lib.length names) - 1;
in
assert lib.assertMsg (builtins.isString file) "A string is required to use this function.";
assert lib.assertMsg ((lib.length names) >= 2) "This function requires a period in the filename.";
builtins.elemAt names ext # [ "file" "ext" ] -> "ext"
