{
  inputs,
  ...
}: let
  wallpaper = {
    dir = "${inputs.self}/assets/wallpapers";
    day = "${wallpaper.dir}/blobs-l.png";
    night = "${wallpaper.dir}/blobs-d.png";
  };
in {
  wayland.windowManager.hyprland.settings = {
    #################
    ### AUTOSTART ###
    #################
    # https://wiki.hypr.land/Configuring/Keywords/#executing
    # Autostart necessary processes (like notifications daemons, status bars, etc.)

    exec-once = [
      "swww img ${wallpaper.day}"
      #"nm-applet --indicator"

      #exec-once = wl-paste --type text --watch cliphist store  # Stores only text data
      #exec-once = wl-paste --type image --watch cliphist store  # Stores only image data
      #exec-once = ~/.config/hypr/scripts/themes.sh  # Set cursors, icons, themes
      #exec-once = ~/.config/hypr/scripts/wallpaper.sh  # Set wallpaper

      # Silently start Firefox on ws2 at login
      #"[workspace 2 silent] firefox"
    ];

    exec = [ ];
  };
}
