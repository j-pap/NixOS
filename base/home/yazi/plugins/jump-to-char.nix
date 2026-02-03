{
  pkgs,
  ...
}:
let
  pluginName = "jump-to-char";
in
{
  # Vim-like f<char> - jump to the next file whose name starts with <char>
  programs.yazi = {
    keymap.mgr.prepend_keymap = [
      {
        desc = "Jump to char";
        on = "f";
        run = "plugin ${pluginName}";
      }
      /*
        {
          # Move filter from 'f' to 'F'
          desc = "Filter files";
          on = "F";
          run = "filter --smart";
        }
      */
    ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
