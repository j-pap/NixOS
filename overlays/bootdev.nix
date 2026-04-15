final: prev: {
  bootdev-cli = prev.bootdev-cli.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "1.28.0";
      src = final.fetchFromGitHub {
        owner = "bootdotdev";
        repo = "bootdev";
        rev = "v${finalAttrs.version}";
        hash = "sha256-sBPId1wEsIG1E+sf+pbqfz0xW0+PHVAoRYTkFLXpWOU=";
      };
      /*
        src = oldAttrs.src // {
          rev = "v${finalAttrs.version}";
          hash = "sha256-sBPId1wEsIG1E+sf+pbqfz0xW0+PHVAoRYTkFLXpWOU=";
        };
      */
    }
  );
}
