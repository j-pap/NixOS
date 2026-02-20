{
  pkgs,
  ...
}:
{
  # Linting
  programs.nixvim = {
    autoCmd = [
      # Create autocommand which carries out the actual linting
      # on the specified events.
      {
        event = [
          "BufEnter"
          "BufWritePost"
          "InsertLeave"
        ];
        callback.__raw = ''
          function()
            require('lint').try_lint()
          end
        '';
        #desc = "";
        group = "lint";
      }
    ];

    autoGroups.lint.clear = true;

    # Be sure to install the corresponding pkg for the below linters
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        go-tools
        #golangci-lint
        markdownlint-cli
        ruff
        shellcheck
        ;
    };

    plugins.lint = {
      enable = true;
      lintersByFt = {
        bash = [ "shellcheck" ];
        go = [
          #"golangci-lint"
          "staticcheck"
        ];
        markdown = [
          "markdownlint"
          #"vale"
        ];
        nix = [ "nix" ];
        python = [ "ruff" ];
      };
    };
  };
}
