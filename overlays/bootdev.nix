final: prev: {
  bootdev-cli = prev.bootdev-cli.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "1.29.0";
      src = final.fetchFromGitHub {
        owner = "bootdotdev";
        repo = "bootdev";
        rev = "v${finalAttrs.version}";
        hash = "sha256-i1U1AsFB/z3h/Aj+YSrfi/U1GWUyawfuL2zJiCWWPgI=";
      };
      /*
        src = oldAttrs.src // {
          rev = "v${finalAttrs.version}";
          hash = "";
        };
      */
    }
  );
}
