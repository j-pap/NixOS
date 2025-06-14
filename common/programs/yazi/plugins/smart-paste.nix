let
  pluginName = "smart-paste";
in {
  programs.yazi.keymap.mgr.prepend_keymap = [
    {
      desc = "Paste into the hovered directory or CWD";
      on = "p";
      run = "plugin ${pluginName}";
    }
  ];

  xdg.configFile."yazi/plugins/${pluginName}.yazi/main.lua".text = ''
    --- @sync entry
    return {
      entry = function()
        local h = cx.active.current.hovered
        if h and h.cha.is_dir then
          ya.emit("enter", {})
          ya.emit("paste", {})
          ya.emit("leave", {})
        else
          ya.emit("paste", {})
        end
      end,
    }
  '';
}
