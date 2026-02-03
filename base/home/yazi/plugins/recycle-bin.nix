{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "recycle-bin";
in
{
  # A Recycle Bin for Yazi with browse, restore, and cleanup capabilities
  programs.yazi = {
    extraPackages = [ pkgs.trash-cli ];

    initLua = ''
      require("${pluginName}"):setup()
    '';

    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Open Recycle Bin menu";
      on = [
        "R"
        "b"
      ];
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
