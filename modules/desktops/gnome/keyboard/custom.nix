{
  flk,
}:
{
  # Settings -> Keyboard -> Keyboard Shortcuts -> Custom Shortcuts
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
    ];
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Print";
      command = "eyedropper";
      name = "Launch color picker";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>Return";
      command = flk.terminal;
      name = "Launch terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Alt><Super>b";
      command = "${flk.browser} --private-window";
      name = "Launch web browser (private)";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Shift><Super>n";
      command = "${flk.terminal} nvim";
      name = "Launch Neovim";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Shift><Super>y";
      command = "${flk.terminal} yazi";
      name = "Launch Yazi";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Shift><Super>slash";
      command = "1password --toggle";
      name = "Launch 1Password";
    };
  };
}
