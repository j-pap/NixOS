{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "toggle-pane";
in
{
  # Toggle the show, hide, and maximize states for different panes
  programs.yazi = {
    initLua = ''
      if os.getenv("NVIM") then
        require("toggle-pane"):entry("min-preview")
      end
    '';

    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Maximize or restore the preview pane";
      on = "T";
      run = "plugin ${pluginName} max-preview";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";

    settings.preview = {
      #max_height = 1000;
      #max_width = 1000;
    };
  };
}
