{
  # GNOME Tweaks
  dconf.settings = {
    # Fonts -> Rendering -> Antialiasing
    "org/gnome/desktop/interface".font-antialiasing = "rgba"; # grayscale, rgba, none

    # Appearance -> Styles -> Icons
    #"org/gnome/desktop/interface".icon-theme = "Adwaita";

    # Appearance -> Background
    "org/gnome/desktop/background" = {
      # Default
      #picture-url = "";
      # Dark
      #picture-url-dark = "";
      # Adjustment
      #picture-options = "zoom";
    };

    # Mouse & Touchpad -> Touchpad Acceleration
    #"org/gnome/desktop/peripherals/touchpad".accel-profile = "default";

    # Windows
    "org/gnome/desktop/wm/preferences" = {
      # Titlebar Buttons
      button-layout = "appmenu:minimize,maximize,close";
      # Window Action Key
      mouse-button-modifier = "<Alt>";
      # Resize with Secondary-Click
      resize-with-right-button = true;
      # Window Focus
      focus-mode = "mouse"; # click, sloppy, mouse
    };
    # Center New Windows
    #"org/gnome/mutter".center-new-windows = true;
  };
}
