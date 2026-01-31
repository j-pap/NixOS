{
  # Forge
  dconf.settings = {
    # Settings
    "org/gnome/shell/extensions/forge" = {
      auto-split-enabled = true;
      focus-border-toggle = true;
      focus-on-hover-enabled = false; # Causes nvim keybinding issues
      move-pointer-focus-enabled = true;
      window-gap-hidden-on-single = true;
      window-gap-size = 5;
      window-gap-size-increment = 1;
    };

    # Keybindings
    "org/gnome/shell/extensions/forge/keybindings" = {
      # Tiling
      window-focus-down = [ "<Super>j" ];
      window-focus-left = [ "<Super>h" ];
      window-focus-right = [ "<Super>l" ];
      window-focus-up = [ "<Super>k" ];
      window-gap-size-decrease = [ "<Control><Super>minus" ];
      window-gap-size-increase = [ "<Control><Super>plus" ];
      window-move-down = [ "<Shift><Super>j" ];
      window-move-left = [ "<Shift><Super>h" ];
      window-move-right = [ "<Shift><Super>l" ];
      window-move-up = [ "<Shift><Super>k" ];
      window-resize-bottom-decrease = [ "<Shift><Control><Super>i" ];
      window-resize-bottom-increase = [ "<Control><Super>u" ];
      window-resize-left-decrease = [ "<Shift><Control><Super>o" ];
      window-resize-left-increase = [ "<Control><Super>y" ];
      window-resize-right-decrease = [ "<Shift><Control><Super>y" ];
      window-resize-right-increase = [ "<Control><Super>o" ];
      window-resize-top-decrease = [ "<Shift><Control><Super>u" ];
      window-resize-top-increase = [ "<Control><Super>i" ];
      window-snap-center = [ ];
      window-snap-one-third-left = [ ];
      window-snap-one-third-right = [ ];
      window-snap-two-third-left = [ ];
      window-snap-two-third-right = [ ];
      window-swap-down = [ ];
      window-swap-last-active = [ ];
      window-swap-left = [ ];
      window-swap-right = [ ];
      window-swap-up = [ ];
      window-toggle-always-float = [ "<Control><Super>y" ];
      window-toggle-float = [ "<Super>y" ];

      # Container
      con-split-horizontal = [ ];
      con-split-layout-toggle = [ "<Super>o" ];
      con-split-vertical = [ ];
      con-stacked-layout-toggle = [ ];
      con-tabbed-layout-toggle = [ ];
      con-tabbed-showtab-decoration-toggle = [ ];

      # Workspace
      workspace-active-tile-toggle = [
        #"<Shift><Super>w"
      ];

      # Appearance
      focus-border-toggle = [ "<Super>x" ];

      # Other
      prefs-open = [ "<Super>Period" ];
      prefs-tiling-toggle = [ "<Super>w" ];
    };
  };

  # Window overrides
  xdg.configFile."forge/config/windows.json".text = builtins.toJSON {
    overrides = [
      {
        wmClass = "org.gnome.Shell.Extensions";
        wmTitle = "Forge Settings";
        mode = "float";
      }
      {
        wmClass = "Gnome-initial-setup";
        mode = "float";
      }
      {
        wmClass = "org.gnome.Calculator";
        mode = "float";
      }
      {
        wmClass = "gnome-terminal-server";
        wmTitle = "Preferences – General";
        mode = "float";
      }
      {
        wmClass = "gnome-terminal-preferences";
        mode = "float";
      }
      {
        wmClass = "Guake";
        mode = "float";
      }
      {
        wmClass = "zoom";
        mode = "float";
      }
      {
        wmClass = "firefox";
        wmTitle = "About Mozilla Firefox";
        mode = "float";
      }
      {
        wmClass = "firefox";
        wmTitle = "!Mozilla Firefox";
        mode = "float";
      }
      {
        wmClass = "org.mozilla.firefox.desktop";
        wmTitle = "About Mozilla Firefox";
        mode = "float";
      }
      {
        wmClass = "org.mozilla.firefox.desktop";
        wmTitle = "!Mozilla Firefox";
        mode = "float";
      }
      {
        wmClass = "thunderbird";
        wmTitle = "About Mozilla Thunderbird";
        mode = "float";
      }
      {
        wmClass = "thunderbird";
        wmTitle = "!Mozilla Thunderbird";
        mode = "float";
      }
      {
        wmClass = "org.mozilla.Thunderbird.desktop";
        wmTitle = "About Mozilla Thunderbird";
        mode = "float";
      }
      {
        wmClass = "org.mozilla.Thunderbird.desktop";
        wmTitle = "!Mozilla Thunderbird";
        mode = "float";
      }
      {
        wmClass = "evolution-alarm-notify";
        mode = "float";
      }
      {
        wmClass = "variety";
        mode = "float";
      }
      {
        wmClass = "update-manager";
        mode = "float";
      }
    ];
  };
}
