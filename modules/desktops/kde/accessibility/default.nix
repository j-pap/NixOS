{
  lib,
}:
{
  # System Settings -> Accessibility
  programs.plasma = {
    kwin.effects = {
      # Zoom & Magnifier -> Full screen
      zoom = {
        enable = lib.mkDefault true;
        #pixelGridZoom = 15.0;
        #mousePointer = "scale"; # scale, keep, hide
        #mouseTracking = "proportional"; # proportional, centered, push, disabled
        #textCursorTracking.enable = false;
        #scrollGestureModKeys = "Meta+Control"; # Ctrl is spelled out here
        #focusTracking.enable = null; # ???
      };

      # Zoom & Magnifier -> Magnify region
      magnifier = {
        #enable = lib.mkDefault false;
        #width = 200;
        #height = 200;
      };

      # Zoom & Magnifier -> Zoom factor
      #zoom.zoomFactor = 1.20;
    };

    # Invert
    #kwin.effects.invert.enable = false;

    # Shake Cursor
    #kwin.effects.shakeCursor.enable = true;
  };
}
