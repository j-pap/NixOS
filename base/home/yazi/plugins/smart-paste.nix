{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "smart-paste";
in
{
  # Paste files into the hovered directory or to the CWD if hovering over a file
  programs.yazi = {
    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Paste into the hovered directory or CWD";
      on = "p";
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
