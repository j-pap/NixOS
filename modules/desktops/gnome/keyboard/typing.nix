{
  # Settings -> Keyboard -> Keyboard Shortcuts -> Typing
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      switch-input-source = [
        #"<Super>space"
      ];
      switch-input-source-backward = [
        #"<Shift><Super>space"
      ];
    };

    # Hidden?
    "org/gnome/mutter/keybindings".cancel-input-capture = [
      #"<Super><Shift>Escape"
    ];
  };
}
