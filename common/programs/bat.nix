{
  pkgs,
  myUser,
  ...
}: {
  home-manager.users.${myUser} = {
    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };

    programs.bat = {
      enable = true;
      config.pager = "less -FR";

      extraPackages = builtins.attrValues {
        inherit (pkgs.bat-extras)
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ;
      };
    };
  };
}
