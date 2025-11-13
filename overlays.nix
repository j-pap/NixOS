final: prev: {
  iosvmata = prev.callPackage ./pkgs/fonts/iosvmata.nix { };
  pragmasevka = prev.callPackage ./pkgs/fonts/pragmasevka.nix { };

  nix-plugins = prev.nix-plugins.overrideAttrs (old: {
    buildInputs = [
      final.boost
      final.nix
    ];
  });
}
