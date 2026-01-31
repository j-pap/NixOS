{
  # Settings -> Keyboard -> Keyboard Shortcuts -> Navigation
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      show-desktop = [ "<Super>d" ];
      move-to-monitor-down = [
        #"<Super><Shift>Down"
        "<Shift><Alt><Super>Down"
        "<Shift><Alt><Super>j"
      ];
      move-to-monitor-left = [
        #"<Super><Shift>Left"
        "<Shift><Alt><Super>Left"
        "<Shift><Alt><Super>h"
      ];
      move-to-monitor-right = [
        #"<Super><Shift>Right"
        "<Shift><Alt><Super>Right"
        "<Shift><Alt><Super>l"
      ];
      move-to-monitor-up = [
        #"<Super><Shift>Up"
        "<Shift><Alt><Super>Up"
        "<Shift><Alt><Super>k"
      ];

      # Hidden
      move-to-workspace-down = [
        #"<Control><Shift><Alt>Down"
      ];
      move-to-workspace-left = [
        #"<Super><Shift>Page_Up"
        "<Shift><Control><Super>Left"
        "<Shift><Control><Super>h"
      ];
      move-to-workspace-right = [
        #"<Super><Shift>Page_Down"
        "<Shift><Control><Super>Right"
        "<Shift><Control><Super>l"
      ];
      # Hidden
      move-to-workspace-up = [
        #"<Control><Shift><Alt>Up"
      ];

      #move-to-workspace-last = [ "<Super><Shift>End" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];
      move-to-workspace-10 = [ "<Shift><Super>0" ];

      #switch-applications = [ "<Super>Tab" "<Alt>Tab" ];
      # Hidden
      #switch-applications-backward = [ "<Shift><Super>Tab" "<Shift><Alt>Tab" ];

      #switch-panels = [ "<Control><Alt>Tab" ];
      # Hidden
      #switch-panels-backward = [ "<Shift><Control><Alt>Tab" ];

      #cycle-panels = [ "<Control><Alt>Escape" ];
      # Hidden
      #cycle-panels-backward = [ "<Shift><Control><Alt>Escape" ];

      #switch-to-workspace-last = [ "<Super>End" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
      switch-to-workspace-left = [
        #"<Super>Page_Up"
        "<Control><Super>Left"
        "<Control><Super>h"
      ];
      switch-to-workspace-right = [
        #"<Super>Page_Down"
        "<Control><Super>Right"
        "<Control><Super>l"
      ];
      #switch-windows = [ ];

      #cycle-windows = [ "<Alt>Escape" ];
      # Hidden
      #cycle-windows-backward = [ "<Shift><Alt>Escape" ];

      #cycle-group = [ "<Alt>F6" ];
      # Hidden
      #cycle-group-backward = [ "<Shift><Alt>F6" ];

      #switch-group = [ "<Super>Above_Tab" "<Alt>Above_Tab" ];
      # Hidden
      #switch-group-backward = [ "<Shift><Super>Above_Tab" "<Shift><Alt>Above_Tab" ];
    };

    # Reassign as empty so switch-to-workspace-# can be assigned (Hidden)
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };
  };
}
