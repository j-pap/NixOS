{
  programs.bash = {
    enable = true;
    shellAliases = {
      # Directories
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ".df" = "cd /etc/nixos";
      "ls" = "eza --long --header --group-directories-first --links --group --modified --git --icons";
      "lsa" =
        "eza --all --long --header --group-directories-first --links --group --modified --git --icons";
      "lt" = "eza --tree";
      "lta" = "eza --tree --all";

      # Misc
      "bonsai" = "cbonsai --screensaver";
      "ff" = "fastfetch";
      "n" = "nvim";
      "swim" = "asciiquarium";

      # Network
      "showdns" = "nmcli device show \"$@\" | grep DNS";

      # Nix
      "nix-diff" = "nix store diff-closures /run/current-system \"$@\"";
      "nix-eval" = "cd /etc/nix/nixpkgs && nix repl .";
      "nix-host" = "nixos-rebuild build --build-host \"$@\"";

      # Pictures
      "exifinfo" = "exiftool -a -g -s \"$@\"";
      "exifstrip" = "exiftool -All= \"$@\"";
    };
  };
}
