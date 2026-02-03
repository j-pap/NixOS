{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "vcs-files";
in
{
  # Show Git file changes in Yazi
  programs.yazi = {
    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Show Git file changes";
      on = [
        "g"
        "c"
      ];
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
