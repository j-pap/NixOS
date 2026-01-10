{
  pkgs,
  ...
}:
let
  pluginName = "chmod";
in
{
  programs.yazi = {
    keymap.mgr.prepend_keymap = [
      {
        desc = "Chmod on selected files";
        on = [
          "c"
          "m"
        ];
        run = "plugin ${pluginName}";
      }
    ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
