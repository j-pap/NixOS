{
  wayland.windowManager.hyprland.settings = {
    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################
    # https://wiki.hypr.land/Configuring/Window-Rules/

    windowrule = [
      # Assign app to workspace
      #"workspace 1, class:^(kitty)$"
      #"workspace 2, class:^(firefox)$"
      #"match:class ^(kitty)$, workspace 1"
      #"match:class ^(firefox)$, workspace 2"

      # 1Password
      "float, size <70% <80%, center, noscreenshare, class:^(1[p|P]assword)$"
      #"match:class ^(1[p|P]assword)$, float, size (monitor_w*0.7) (monitor_h*0.8), center, noscreenshare"

      /*
      # Not supported in v0.52
      {
        name = "ignore-maximize-events";
        "match:class" = ".*";
        suppress_event = "maximize";
      }
      {
        name = "fix-xwayland-drags";
        "match:class" = "^$";
        "match:title" = "^$";
        "match:xwayland" = true;
        "match:float" = true;
        "match:fullscreen" = false;
        "match:pin" = false;
        no_focus = true;
      }
      */
      # Ignore maximize events
      "suppressevent maximize, class:.*"
      #"match:class .*, suppress_event maximize"

      # Fix XWayland dragging issues
      "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
      #"match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus"

      # Prevent idle from starting if fullscreen'd/media playing
      "idleinhibit fullscreen, fullscreen:1"
      "idleinhibit always, tag:noidle"
      #"idleinhibit always, title:^(Youtube)$"
      #"idleinhibit always, class:^(spotify)$"
      #"match:fullscreen true, idle_inhibit fullscreen"
      #"match:tag noidle, idle_inhibit always"
      #"match:class ^(spotify)$, idle_inhibit always"
      #"match:title ^(Youtube)$, idle_inhibit always"
    ];


    # https://wiki.hypr.land/Configuring/Window-Rules/#layer-rules
    # `hyprctl layers`
    layerrule = [ ];


    # https://wiki.hypr.land/Configuring/Workspace-Rules/
    workspace = [
      "special:scratchpad, on-created-empty:[float; size <80% <80%; center] $terminal, persistent:false"
    ];
  };
}
