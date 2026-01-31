{
  # Settings -> Keyboard -> Keyboard Shortcuts -> System
  dconf.settings = {
    #"org/gnome/shell/keybindings".focus-active-notification = [ "<Super>n" ];
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [
        #"<Super>l"
        "<Super>Escape"
      ];
      logout = [
        #"<Control><Alt>Delete"
        "<Shift><Super>Escape"
      ];
    };
    #"org/gnome/shell/keybindings".toggle-quick-settings = [ "<Super>s" ];
    #"org/gnome/settings-daemon/plugins/media-keys".power = [ ];
    #"org/gnome/settings-daemon/plugins/media-keys".reboot = [ ];
    "org/gnome/mutter/wayland/keybindings".restore-shortcuts = [ ];

    #"org/gnome/shell/keybindings".toggle-application-view = [ "<Super>a" ];
    "org/gnome/shell/keybindings".toggle-message-tray = [
      #"<Super>m"
      "<Super>v"
    ];
    #"org/gnome/shell/keybindings".toggle-overview = [ ];
    #"org/gnome/desktop/wm/keybindings".panel-run-dialog = [ "<Alt>F2" ];
  };
}
