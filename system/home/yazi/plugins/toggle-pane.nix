{
  pkgs,
  ...
}:
let
  pluginName = "toggle-pane";
in
{
  programs.yazi = {
    keymap.mgr.prepend_keymap = [
      {
        desc = "Maximize or restore the preview pane";
        on = "T";
        run = "plugin ${pluginName} max-preview";
      }
    ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";

    settings.preview = {
      #max_height = 1000;
      #max_width = 1000;
    };
  };
}
