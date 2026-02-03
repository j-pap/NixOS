{
  pkgs,
  ...
}:
let
  pluginName = "piper";
in
{
  # Pipe any shell command as a previewer
  programs.yazi = {
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        glow
        sqlite
        ;
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";

    settings.plugin.prepend_previewers = [
      {
        url = "*.tar*";
        run = "${pluginName} --format=url -- tar tf \"$1\"";
      }
      {
        url = "*.csv";
        run = "${pluginName} -- bat -p --color=always \"$1\"";
      }
      {
        url = "*.md";
        run = "${pluginName} -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
      }
      {
        url = "*/";
        run = "${pluginName} -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
      }
      {
        mime = "application/sqlite3";
        run = "${pluginName} -- sqlite3 \"$1\" \".schema --indent\"";
      }
    ];
  };
}
