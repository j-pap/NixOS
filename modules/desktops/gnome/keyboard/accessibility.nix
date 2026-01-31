{
  # Settings -> Keyboard -> Keyboard Shortcuts -> Accessibility
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      #decrease-text-size = [ ];
      #toggle-contrast = [ ];
      #increase-text-size = [ ];
      #on-screen-keyboard = [ ];
      screenreader = [
        #"<Alt><Super>s"
      ];
      magnifier = [
        #"<Alt><Super>8"
      ];
      magnifier-zoom-in = [
        #"<Alt><Super>equal"
      ];
      magnifier-zoom-out = [
        #"<Alt><Super>minus"
      ];
    };
  };
}
