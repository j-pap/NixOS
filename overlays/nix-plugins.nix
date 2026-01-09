final: prev: {
  nix-plugins = prev.nix-plugins.overrideAttrs (old: {
    buildInputs = [
      final.boost
      final.nix
    ];
  });
}
