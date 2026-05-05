{
  config,
  pkgs,
  ...
}:
{
  # Highlight, edit, and navigate code
  programs.nixvim = {
    extraPackages = builtins.attrValues {
      inherit (pkgs) tree-sitter;
    };

    plugins.treesitter = {
      enable = true;
      package = pkgs.vimPlugins.nvim-treesitter;

      grammarPackages = builtins.attrValues {
        inherit (config.programs.nixvim.plugins.treesitter.package.builtGrammars)
          bash
          css
          dockerfile
          go
          html
          json
          lua
          markdown
          markdown_inline
          nix
          php
          printf
          python
          regex
          sql
          terraform
          toml
          vim
          vimdoc
          xml
          yaml
          ;
      };
      # Whether to install grammars defined in grammarPackages
      nixGrammars = true;

      highlight = {
        enable = true;
        disable = [ ];
      };

      indent.enable = true;

      # There are additional nvim-treesitter modules that you can use to interact
      # w/ nvim-treesitter. You should go explore a few and see what interests you:
      #
      # - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      # - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      # - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    };
  };
}
