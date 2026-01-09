{
  lib,
  osConfig,
  ...
}:
let
  flk = osConfig.flake.host.monitor;
  name = if (flk.name == null) then "" else flk.name;
  width = flk.width;
  height = flk.height;
  refresh = flk.refresh;
  whr =
    if
      lib.any (v: v == null) [
        width
        height
        refresh
      ]
    then
      "preferred"
    else
      "${width}x${height}@${refresh}";
  position = "auto";
  scale = if (flk.scale == "") then "auto" else (lib.substring 0 4 flk.scale);
in
{
  wayland.windowManager.hyprland.settings = {
    ################
    ### MONITORS ###
    ################
    # https://wiki.hypr.land/Configuring/Monitors/
    # `hyprctl monitors all`

    monitor = lib.mkDefault [
      #", preferred, auto, auto"
      "${name}, ${whr}, ${position}, ${scale}"
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
