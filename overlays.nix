final: prev: {
  iosvmata = prev.callPackage ./pkgs/fonts/iosvmata.nix { };
  pragmasevka = prev.callPackage ./pkgs/fonts/pragmasevka.nix { };

  nix-plugins = prev.nix-plugins.overrideAttrs (old: {
    buildInputs = [
      final.boost
      final.nix
    ];
    patches = (old.patches or [ ]) ++ [(builtins.fetchurl {
      url = "https://patch-diff.githubusercontent.com/raw/shlevy/nix-plugins/pull/23.patch";
      sha256 = "1risxg5fddk2aplrrriww567jbmqpryrd16rm1cw07xb20m74g93";
    })];
  });
}
