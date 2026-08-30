{
  programs.bash = {
    enable = true;
    shellAliases = {
      # Directories
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ".df" = "cd /etc/nixos";
      ls = "eza";
      lsa = "eza --all";
      ll = "eza --long --header --group-directories-first --links --group --modified --git --icons always";
      lla = "eza --long --all --header --group-directories-first --links --group --modified --git --icons always";
      lt = "eza --tree";
      lta = "eza --tree --all";
      ltl = "eza --tree --long --header --group-directories-first --links --group --modified --git --icons always";
      ltla = "eza --tree --long --all --header --group-directories-first --links --group --modified --git --icons always";

      # Misc
      bonsai = "cbonsai --screensaver";
      ff = "fastfetch";
      n = "nvim";
      swim = "asciiquarium";
      wttr = "curl wttr.in?0q";

      # Network
      showdns = "nmcli device show \"$@\" | grep DNS";

      # Nix
      nix-diff = "nix store diff-closures /run/current-system \"$@\"";
      nix-eval = "cd /etc/nix/nixpkgs && nix repl .";
      nix-host = "nixos-rebuild build --build-host \"$@\"";

      # Pictures
      exifinfo = "exiftool -a -g -s \"$@\"";
      exifstrip = "exiftool -All= \"$@\"";
    };
  };
}
