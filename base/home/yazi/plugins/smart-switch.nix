{
  lib,
  ...
}:
let
  pluginName = "smart-switch";
in
{
  # Create tab if the tab being switched to does not exist
  programs.yazi.keymap.mgr.prepend_keymap = lib.singleton {
    desc = "Switch or create tab 2";
    on = "2";
    run = "plugin ${pluginName} 1";
  };

  xdg.configFile."yazi/plugins/${pluginName}.yazi/main.lua".text = ''
    --- @sync entry
    local function entry(_, job)
      local cur = cx.active.current
      for _ = #cx.tabs, job.args[1] do
        ya.emit("tab_create", { cur.cwd })
        if cur.hovered then
          ya.emit("reveal", { cur.hovered.url })
        end
      end
      ya.emit("tab_switch", { job.args[1] })
    end

    return { entry = entry }
  '';
}
