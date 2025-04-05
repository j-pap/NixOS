{
  inputs,
  ...
}: let
  pluginName = "jump-to-char";
in {
  programs.yazi = {
    keymap.manager.prepend_keymap = [
      {
        desc = "Jump to char";
        on = "f";
        run = "plugin ${pluginName}";
      }
      { # Move filter from 'f' to 'F'
        desc = "Filter files";
        on = "F";
        run = "filter --smart";
      }
    ];

    plugins.${pluginName} = inputs.yazi-plugins + "/${pluginName}.yazi";
  };
}
