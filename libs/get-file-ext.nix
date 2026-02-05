#######################################
# Obtain a filename's extension
# Globals:
#   names: filename split by ".", a list of strings
#   length: length of names list minus one, an integer
# Arguments:
#   file: filename string to get extension of
# Returns:
#   "file.ext" -> "ext"
#######################################
{
  lib,
}:
file:
let
  names = lib.splitString "." (builtins.baseNameOf file);
  length = (lib.length names) - 1;
in
builtins.elemAt names length
