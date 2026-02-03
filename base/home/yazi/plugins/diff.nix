{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "diff";
in
{
  # Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard
  programs.yazi = {
    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Diff the selected w/ the hovered file";
      on = "<C-d>";
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
