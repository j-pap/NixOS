{
  pkgs,
  ...
}:
let
  pluginName = "full-border";
in
{
  # Add a full border to Yazi to make it look fancier
  programs.yazi = {
    initLua = ''
      require("${pluginName}"):setup {
        -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
        type = ui.Border.ROUNDED,
      }
    '';

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
