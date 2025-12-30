{
  wayland.windowManager.hyprland.settings = {
    #############
    ### INPUT ###
    #############
    # https://wiki.hypr.land/Configuring/Variables/#input

    input = {
      touchpad = {
        disable_while_typing = true;
        natural_scroll = true;
        clickfinger_behavior = true;
        tap-to-click = true;
        drag_lock = 1; # 0 - disabled, 1 - enabled timeout, 2 - enabled sticky
        tap-and-drag = true;
      };
    };

    # https://wiki.hypr.land/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe_distance = 200; # 300 default
    };

    # https://wiki.hypr.land/Configuring/Gestures
    gesture = [
      "3, horizontal, workspace"
    ];
  };
}
