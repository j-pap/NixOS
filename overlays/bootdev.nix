final: prev: {
  bootdev-cli = prev.bootdev-cli.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "1.32.5";
      src = oldAttrs.src.overrideAttrs {
        # hash = finalAttrs.lib.fakeHash;
        hash = "sha256-TaZfb3ykSX7MqdTW+LuE8Ta/nwHQQW3jV3PIlv3UxrU=";
      };
    }
  );
}
