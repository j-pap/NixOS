let
  pluginName = "confirm-quit";
in
{
  # Confirm before quitting if multiple tabs are open
  programs.yazi.keymap.mgr.prepend_keymap = [
    # Reassign 'q' to plugin / leave 'Q' alone
    {
      desc = "Quit the process";
      on = "q";
      run = "plugin ${pluginName}";
    }
    {
      desc = "Quit the process w/o outputting cwd-file";
      on = "Q";
      run = "quit --no-cwd-file";
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
        content = ui.Text("Multiple tabs are open. Are you sure you want to quit?"):wrap(ui.Wrap.YES),
      }
      if yes then
        ya.emit("quit", {})
      end
    end

    return { entry = entry }
  '';
}
