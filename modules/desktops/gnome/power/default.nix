{
  # Settings -> Power -> General
  dconf.settings = {
    #"org/gnome/settings-daemon/plugins/power".power-button-action = "suspend";
    "org/gnome/desktop/interface".show-battery-percentage = true;

    # Settings -> Power -> Power Saving
    "org/gnome/settings-daemon/plugins/power" = {
      # Auto Screen Brightness
      #ambient-enabled = true;
      # Dim Screen
      #idle-dim = true;
      # Auto Power Saver
      #power-saver-profile-on-low-battery = true;

      # Automatic Suspend
      sleep-inactive-battery-timeout = 600; # 10 minutes
      sleep-inactive-ac-timeout = 900; # 15 minutes
    };
  };
}
