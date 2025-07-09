final: prev: {
  nix-plugins = prev.nix-plugins.overrideAttrs (old: {
    buildInputs = [
      final.nixVersions.nix_2_28
      #final.nixVersions.latest
      final.boost
    ];
    patches = (old.patches or [ ]) ++ [ ./pkgs/nix-plugins/nix-plugins.patch ];
  });
}
