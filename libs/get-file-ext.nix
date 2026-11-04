#######################################
# Retrieve a filename's extension
# Globals:
#   parts: path removed & filename split by ".", a list of strings
# Arguments:
#   file: file to get extension from, a string
# Returns:
#   "file.ext" -> "ext"
#######################################
{
  lib,
}:
file:
let
  parts = lib.splitString "." (builtins.baseNameOf file); # "path/to/file.ext" -> [ "file" "ext" ]
in
assert lib.assertMsg (builtins.isString file) "A string is required to use this function.";
assert lib.assertMsg ((lib.length parts) >= 2) "This function requires a period in the filename.";
lib.concatStringsSep "." (lib.drop 1 parts) # [ "file" "ext" ] -> "ext"
