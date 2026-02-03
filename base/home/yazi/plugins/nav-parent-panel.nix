{
  pkgs,
  ...
}:
let
  pluginName = "nav-parent-panel";
in
{
  # Yazi plugin to navigate between sibling directories
  programs.yazi = {
    initLua = ''
      require("${pluginName}"):setup({
        -- quite = true  -- Enable quiet mode (default: true)
      })
    '';

    keymap.mgr.prepend_keymap = [
      {
        desc = "Go to previous sibling directory";
        on = "<C-k>";
        run = "plugin ${pluginName} prev";
      }
      {
        desc = "Go to next sibling directory";
        on = "<C-j>";
        run = "plugin ${pluginName} next";
      }
      {
        desc = "Go to first sibling directory";
        on = "<C-Home>";
        run = "plugin ${pluginName} first";
      }
      {
        desc = "Go to last sibling directory";
        on = "<C-End>";
        run = "plugin ${pluginName} last";
      }
    ];

    plugins.${pluginName} = pkgs.yaziPlugins."${pluginName}";
  };
}
