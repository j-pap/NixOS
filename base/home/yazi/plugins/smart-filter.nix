{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "smart-filter";
in
{
  # Yazi plugin that makes filters smarter
  programs.yazi = {
    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Smart filter";
      on = "F";
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
