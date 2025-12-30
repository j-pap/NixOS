{
  osConfig,
  ...
}: let
  cfg = osConfig.myOptions.desktops.hyprland;
  cfgHosts = osConfig.myHosts;
in {
  wayland.windowManager.hyprland.settings = {
    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################
    # https://wiki.hypr.land/Configuring/Environment-variables/

    env = [
    # Toolkit Backend
      "GDK_BACKEND,wayland,x11,*"
      "QT_QPA_PLATFORM,wayland;xcb"
      "SDL_VIDEODRIVER,wayland"
      "CLUTTER_BACKEND,wayland"

    # XDG Specifications
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"

    # Qt
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      #"QT_QPA_PLATFORMTHEME,Catppuccin-Frappe-Standard-Mauve-Dark"
      "QT_QPA_PLATFORMTHEME,qt6ct"

    # Theming Related
      #"GTK_THEME,Catppuccin-Frappe-Standard-Mauve-Dark"
      "XCURSOR_THEME,${cfg.cursor.name}"
      "XCURSOR_SIZE,${toString cfg.cursor.size}"
      "HYPRCURSOR_THEME,${cfg.cursor.name}"
      "HYPRCURSOR_SIZE,${toString cfg.cursor.size}"

    # Electron
      "ELECTRON_OZONE_PLATFORM_HINT,auto"

    # XWayland Scaling
      "GDK_SCALE,${builtins.toString cfgHosts.scale}"
    ];
  };
}
