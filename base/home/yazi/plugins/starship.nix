{
  pkgs,
  ...
}:
let
  pluginName = "starship";
in
{
  # Starship prompt plugin for Yazi
  programs.yazi = {
    # https://github.com/Rolv-Apneseth/starship.yazi?tab=readme-ov-file#config
    initLua = ''
      require("${pluginName}"):setup()
    '';

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
