{
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    ################
    ### MONITORS ###
    ################
    # https://wiki.hypr.land/Configuring/Monitors/
    # `hyprctl monitors all`

    monitor = lib.mkDefault [
      # name, widthxheight@rate, position, scale
      ", preferred, auto, auto"
    ];

    # https://wiki.hypr.land/Configuring/Variables/#misc
    misc.vrr = 3; # 0 - off, 1 - on, 2 - fullscreen only, 3 - fullscreen video/game content

    # https://wiki.hypr.land/Configuring/Variables/#quirks
    # Not supported in v0.52
    #quirks.prefer_hdr = lib.mkDefault 0; # 0 - off, 1 - always, 2 - gamescope only

    # https://wiki.hypr.land/Configuring/XWayland/
    # https://wiki.hypr.land/Configuring/Variables/#xwayland
    xwayland.force_zero_scaling = false;
  };
}
