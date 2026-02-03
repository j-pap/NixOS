{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "gitui";
in
{
  # Plugin for Yazi to manage git repos with gitui
  programs.yazi = {
    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "run gitui";
      on = [
        "g"
        "i"
      ];
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
