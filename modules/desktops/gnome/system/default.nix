{
  # Settings -> System -> Date & Time
  dconf.settings = {
    # Automatic Time Zone
    "org/gnome/desktop/datetime".automatic-timezone = true;

    # Time Format
    #"org/gnome/desktop/interface".clock-format = "24h";
    #"org/gtk/settings/file-chooser".clock-format = "24h";

    # Clock & Calendar
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      #clock-show-date = true;
    };
  };
}
