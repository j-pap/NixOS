final: prev: {
  bootdev-cli = prev.bootdev-cli.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "1.29.3";
      src = oldAttrs.src.overrideAttrs {
        hash = "sha256-6fdzSwCtJG8SFqInVsOc5EO4g9esMU/z9MYtou1ylFI=";
      };
    }
  );
}
