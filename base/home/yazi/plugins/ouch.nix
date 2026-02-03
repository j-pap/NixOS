{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "ouch";
in
{
  # Yazi plugin to preview/compress archives
  programs.yazi = {
    extraPackages = [ pkgs.ouch ];

    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Compress with ouch";
      on = "C";
      run = "plugin ${pluginName}";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";

    settings = {
      opener.extract = lib.singleton {
        desc = "Extract here with ouch";
        for = "unix";
        run = "${pluginName} d -y %s";
      };
      plugin.prepend_previewers = lib.singleton {
        mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
        run = "${pluginName}";
      };
    };
  };
}
