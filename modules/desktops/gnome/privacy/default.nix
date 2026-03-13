{
  lib,
}:
{
  # Settings -> Privacy & Security
  dconf.settings = {
    # Screen Lock
    "org/gnome/desktop/screensaver" = {
      # Automatic Screen Lock
      #lock-enabled = true;
      # Automatic Screen Lock Delay
      lock-delay = lib.gvariant.mkUint32 5;
    };

    # Location -> Automatic Device Location
    "org/gnome/system/location".enabled = true;

    "org/gnome/desktop/privacy" = {
      # File History
      remember-recent-files = false;
      # File History Duration
      recent-files-max-age = 0;
      # Automatically Empty Trash
      remove-old-trash-files = true;
      # Automatically Delete Temporary Files
      remove-old-temp-files = true;
      # Automatic Deletion Period
      #old-files-age = lib.gvariant.mkUint32 30;

      # Cameras -> Camera Access
      #disable-camera = false;

      # Hidden Options
      #disable-microphone = false;
      report-technical-problems = false;
      send-software-usage-stats = false;
    };
  };
}
