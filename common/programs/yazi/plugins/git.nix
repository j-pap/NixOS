{
  inputs,
  ...
}: let
  pluginName = "git";
in {
  # Show the status of GIt file changes as linemode in the file list
  programs.yazi = {
    initLua = ''
      require("${pluginName}"):setup()

      th.git = th.git or {}
      th.git.modified_sign = "M"
      th.git.added_sign = "A"
      ---th.git.untracked_sign = ""
      ---th.git.ignored_sign = ""
      th.git.deleted_sign = "D"
      ---th.git.updated_sign = ""
    '';

    plugins.${pluginName} = inputs.yazi-plugins + "/${pluginName}.yazi";

    settings.plugin.prepend_fetchers = [
      {
        id = "git";
        name = "*";
        run = pluginName;
      }
      {
        id = "git";
        name = "*/";
        run = pluginName;
      }
    ];
  };
}
