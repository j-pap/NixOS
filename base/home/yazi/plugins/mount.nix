{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "mount";
in
{
  # Mount manager for Yazi
  programs.yazi = {
    extraPackages = [ pkgs.udisks ];

    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Mount manager";
      on = "M";
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
