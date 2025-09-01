{
  myUser,
  ...
}: {
  home-manager.users.${myUser}.programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      ".df" = "cd /etc/nixos";
      "bonsai" = "cbonsai --screensaver";
      "exifinfo" = "exiftool -a -g -s \"$@\"";
      "exifstrip" = "exiftool -All= \"$@\"";
      "ff" = "fastfetch";
      "fishy" = "asciiquarium";
      "ll" = "ls -la";
      "nix-diff" = "nix store diff-closures /run/current-system \"$@\"";
      "nix-host" = "nixos-rebuild build --build-host \"$@\"";
    };
  };
}
