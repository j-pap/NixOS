f: p:
let
  trunc = f: if f < 0 then builtins.ceil f else builtins.floor f;
  pow = b: n: builtins.foldl' builtins.mul 1 (builtins.genList (_: b) n);
in
trunc (f * pow 10 p) / pow 10.0 p
