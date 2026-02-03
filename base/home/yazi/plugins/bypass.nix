{
  pkgs,
  ...
}:
let
  pluginName = "bypass";
in
{
  # Yazi plugin for skipping directories with only a single sub-directory
  programs.yazi = {
    keymap.mgr.prepend_keymap = [
      {
        desc = "Recursively enter parent directory, skipping parents with only a single subdirectory";
        on = "h";
        run = "plugin ${pluginName} reverse";
      }
      {
        desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory";
        on = "l";
        run = "plugin ${pluginName} smart-enter";
      }
    ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
