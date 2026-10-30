final: prev: {
  bootdev-cli = prev.bootdev-cli.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "1.32.6";
      src = oldAttrs.src.overrideAttrs {
        # hash = finalAttrs.lib.fakeHash;
        hash = "sha256-40MI8CHvDmxVHYqnnCV2cdN4yL54feWjXrKgbEvjFQM=";
      };
    }
  );
}
