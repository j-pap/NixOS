{
  lib,
  pkgs,
  ...
}:
let
  pluginName = "mediainfo";
in
{
  # Yazi plugin for previewing media files
  programs.yazi = {
    extraPackages = [ pkgs.mediainfo ];

    keymap.mgr.prepend_keymap = lib.singleton {
      desc = "Toggle media preview metadata";
      on = "<F9>";
      run = "plugin ${pluginName} -- toggle-metadata";
    };

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";

    settings = {
      plugin = {
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "${pluginName}";
          }
          {
            mime = "application/subrip";
            run = "${pluginName}";
          }
          {
            mime = "application/postscript";
            run = "${pluginName}";
          }
        ];
        prepend_previewers = [
          {
            mime = "{audio,video,image}/*";
            run = "${pluginName}";
          }
          {
            mime = "application/subrip";
            run = "${pluginName}";
          }
          {
            mime = "application/postscript";
            run = "${pluginName}";
          }
        ];
      };
      tasks.image_alloc = 1073741824; # = 1024*1024*1024 = 1024MB
    };

    theme.spot = {
      title.fg = "green";
      tbl_col.fg = "blue";
    };
  };
}
