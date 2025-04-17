{
  myUser,
  nixPath,
  ...
}: {
  home-manager.users.${myUser}.programs.bash = {
    enable = true;
    #initExtra = '''';
    shellAliases = {
      ".." = "cd ..";
      ".df" = "cd ${nixPath}";
      "bonsai" = "cbonsai --screensaver";
      "exifinfo" = "exiftool -a -g -s \"$@\"";
      "exifstrip" = "exiftool -All= \"$@\"";
      "ff" = "fastfetch";
      "fishy" = "asciiquarium";
      "ll" = "ls -la";
      "nix diff" = "nixos-rebuild build && nix store diff-closures /run/current-system ./result";
    };
  };
}
