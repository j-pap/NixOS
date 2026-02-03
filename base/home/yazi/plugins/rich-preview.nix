{
  pkgs,
  ...
}:
let
  pluginName = "rich-preview";
in
{
  # Preview file types using rich in Yazi
  programs.yazi = {
    extraPackages = [ pkgs.rich-cli ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";

    settings.plugin.prepend_previewers = [
      {
        url = "*.csv";
        run = "${pluginName}";
      }
      /*
        {
          url = "*.md";
          run = "${pluginName}";
        }
      */
      {
        url = "*.json";
        run = "${pluginName}";
      }
    ];
  };
}
