final: prev: {
  nix-plugins = prev.nix-plugins.overrideAttrs (old: {
    buildInputs = [
      final.nixVersions.latest
      final.boost
    ];
    patches = (old.patches or [ ]) ++ [ ./pkgs/nix-plugins/nix-plugins.patch ];
  });
}
