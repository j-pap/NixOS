{
  # Settings -> Keyboard -> Keyboard Shortcuts -> Windows
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      #activate-window-menu = [ "<Alt>space" ];
      close = [
        #"<Alt>F4"
        "<Super>q"
      ];
      minimize = [
        #"<Super>h"
      ];
      #lower = [ ];
      #maximize = [ "<Super>Up" ];
      #maximize-horizontally = [ ];
      #maximize-vertically = [ ];
      #begin-move = [ "<Alt>F7" ];
      #raise = [ ];
      #raise-or-lower = [ ];
      #begin-resize = [ "<Alt>F8" ];
      #unmaximize = [ "<Super>Down" "<Alt>F5" ];
      toggle-fullscreen = [ "<Super>F11" ];
      toggle-maximized = [
        #"<Alt>F10"
        "<Super>m"
      ];
      #toggle-on-all-workspaces = [ ];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [
        #"<Super>Left"
      ];
      toggle-tiled-right = [
        #"<Super>Right"
      ];
    };
  };
}
