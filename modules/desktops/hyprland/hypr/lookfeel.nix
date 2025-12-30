{
  wayland.windowManager.hyprland.settings = {
    #####################
    ### LOOK AND FEEL ###
    #####################
    # https://wiki.hypr.land/Configuring/Variables/#variable-types

    # https://wiki.hypr.land/Configuring/Variables/#general
    general = {
      border_size = 2;
      gaps_in = 5;
      gaps_out = 10;
      "col.inactive_border" = "rgba(595959aa)";
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      layout = "dwindle";
      resize_on_border = true; # Resize windows by clicking and dragging on borders

      # https://wiki.hypr.land/Configuring/Tearing/
      allow_tearing = false;

      # https://wiki.hypr.land/Configuring/Variables/#snap
      snap = {
        enabled = false;
      };
    };

    # https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;
      active_opacity = 0.9;
      inactive_opacity = 0.9;
      dim_inactive = true;
      dim_strength = 0.25;
      dim_special = 0.2;

      # https://wiki.hypr.land/Configuring/Variables/#blur
      blur = {
        enabled = true;
        size = 3;
        passes = 2;
        new_optimizations = true;
        contrast = 0.75;
        brightness = 0.60;
        vibrancy = 0.1696;
        special = true;
      };

      # https://wiki.hypr.land/Configuring/Variables/#shadow
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
    };

    # https://wiki.hypr.land/Configuring/Variables/#animations
    animations = {
      enabled = true;

      # https://wiki.hypr.land/Configuring/Animations/#general
      animation = [
        "global,        1, 10,   default"
        "windows,       1, 4.79, easeOutQuint"
        "windowsIn,     1, 4.1,  easeOutQuint, popin 87%"
        "windowsOut,    1, 1.49, linear,       popin 87%"
        "layers,        1, 3.81, easeOutQuint"
        "layersIn,      1, 4,    easeOutQuint, fade"
        "layersOut,     1, 1.5,  linear,       fade"
        "fade,          1, 3.03, quick"
        "fadeIn,        1, 1.73, almostLinear"
        "fadeOut,       1, 1.46, almostLinear"
        "fadeLayersIn,  1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "border,        1, 5.39, easeOutQuint"
        "workspaces,    1, 1.94, almostLinear, fade"
        "workspacesIn,  1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
        "zoomFactor,    1, 7,    quick"
      ];

      # https://wiki.hypr.land/Configuring/Animations/#curves
      bezier = [
        "easeOutQuint,   0.23, 1,    0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear,         0,    0,    1,    1"
        "almostLinear,   0.5,  0.5,  0.75, 1"
        "quick,          0.15, 0,    0.1,  1"
      ];
    };

    # https://wiki.hypr.land/Configuring/Dwindle-Layout/
    dwindle = {
      pseudotile = true; # Pseudotiled windows retain their floating size when tiled
      force_split = 2; # 0 -> follow mouse, 1 -> split left, 2 -> split right
      preserve_split = true; # You probably want this
    };

    # https://wiki.hypr.land/Configuring/Master-Layout/
    master = {
      new_status = "master";
    };

    # https://wiki.hypr.land/Configuring/Variables/#misc
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      focus_on_activate = true;
    };

    # https://wiki.hypr.land/Configuring/Variables/#cursor
    cursor = {
      hide_on_key_press = true;
    };
  };
}
