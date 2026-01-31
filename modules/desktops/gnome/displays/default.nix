{
  lib,
  ...
}:
{
  # Settings -> Displays
  dconf.settings = {
    "org/gnome/mutter".experimental-features = [
      "scale-monitor-framebuffer"
      "variable-refresh-rate"
      "xwayland-native-scaling"
    ];

    # Scale is set via systemActivation script

    # Night Light
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      #night-light-schedule-automatic = true;
      night-light-temperature = lib.gvariant.mkUint32 4700;
    };
  };
}
