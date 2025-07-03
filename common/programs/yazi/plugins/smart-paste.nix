{
  pkgs,
  ...
}: let
  pluginName = "smart-paste";
in {
  programs.yazi = {
    keymap.mgr.prepend_keymap = [
      {
        desc = "Paste into the hovered directory or CWD";
        on = "p";
        run = "plugin ${pluginName}";
      }
    ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
