{
  lib,
  ...
}:
let
  pluginName = "smart-tab";
in
{
  # Create a tab and enter the hovered directory
  programs.yazi.keymap.mgr.prepend_keymap = lib.singleton {
    desc = "Enter the hovered directory in a new tab";
    on = "t";
    run = "plugin ${pluginName}";
  };

  xdg.configFile."yazi/plugins/${pluginName}.yazi/main.lua".text = ''
    --- @sync entry
    return {
      entry = function()
        local h = cx.active.current.hovered
        ya.emit("tab_create", h and h.cha.is_dir and { h.url } or { current = true })
      end,
    }
  '';
}
