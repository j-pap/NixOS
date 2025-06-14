let
  pluginName = "confirm-quit";
in {
  # Confirm before quitting if multiple tabs are open
  programs.yazi.keymap.mgr.prepend_keymap = [
    # Reverse q/Q actions
    {
      desc = "Quit the process w/o outputting cwd-file";
      on = "q";
      run = "plugin ${pluginName} --no-cwd-file";
    }
    {
      desc = "Quit the process";
      on = "Q";
      run = "plugin ${pluginName}";
    }
  ];

  xdg.configFile."yazi/plugins/${pluginName}.yazi/main.lua".text = ''
    local count = ya.sync(function() return #cx.tabs end)

    local function entry()
      if count() < 2 then
        return ya.emit("quit", {})
      end

      local yes = ya.confirm {
        pos = { "center", w = 60, h = 10 },
        title = "Quit?",
        content = ui.Text("There are multiple tabs open. Are you sure you want to quit?"):wrap(ui.Wrap.YES),
      }
      if yes then
        ya.emit("quit", {})
      end
    end

    return { entry = entry }
  '';
}
