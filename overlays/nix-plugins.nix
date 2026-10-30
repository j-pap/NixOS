final: prev:
let
  getNixVer =
    v:
    final.lib.concatStringsSep "_" [
      "${final.lib.versions.major v}"
      "${final.lib.versions.minor v}"
    ];
in
{
  nix-plugins =
    (prev.nix-plugins.overrideAttrs (oldAttrs: {
      # patches = (oldAttrs.patches or [ ]) ++ [
      #   # https://github.com/shlevy/nix-plugins/pull/25
      #   (final.fetchpatch {
      #     name = "nix-plugins-nix-2.33.patch";
      #     url = "https://github.com/shlevy/nix-plugins/commit/75b5f1d79923243759ddb8261df7d24df8ad2d5b.patch";
      #     hash = "sha256-q3f3CQhJDBU8MsSaPDWZv5V1bUxL9spq/aUaOvz0bns=";
      #   })
      #   # https://github.com/shlevy/nix-plugins/pull/26
      #   (final.fetchpatch {
      #     name = "nix-plugins-nix-2.34.patch";
      #     url = "https://github.com/shlevy/nix-plugins/commit/51ab78357ab6eb1f382c3f64bdb8fbaf742d8dec.patch";
      #     hash = "sha256-7jE8MoZJiTXx0O3SGqXQ7PhwqK7txEoESWXWmMq9Dts=";
      #   })
      # ];
    })).override
      {
        nixComponents = final.nixVersions."nixComponents_${getNixVer final.nix.version}";
      };
}
