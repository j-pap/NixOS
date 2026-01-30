{
  stylix,
  theme,
}:
{
  # System Settings -> Colors & Themes
  programs.plasma = {
    configFile.kdeglobals.KDE = {
      # Global Theme -> Switch to Dark Mode at Night
      AutomaticLookAndFeel = true;
      AutomaticLookAndFeelOnIdle = false;

      # Global Theme -> Light
      #DefaultLightLookAndFeel = theme.light; # org.kde.breeze.desktop, org.kde.breezetwilight.desktop

      # Global Theme -> Dark
      #DefaultDarkLookAndFeel = theme.dark; # org.kde.breezedark.desktop
    };
    workspace = {
      # Global Theme
      #lookAndFeel = null; # org.kde.breeze.desktop, org.kde.breezedark.desktop, org.kde.breezetwilight.desktop (Static; No theme switch)

      # Colors
      #colorScheme = null; # BreezeClassic, BreezeDark, BreezeLight

      # Application Style
      #widgetStyle = "breeze"; # breeze, fusion, windows

      # Plasma Style
      #theme = null; # breeze-dark, breeze-light (Static; No theme switch)

      # Window Decorations
      windowDecorations = {
        #library = "org.kde.breeze";
        #theme = "Breeze";
      };
    };
    # Window Decorations -> Configure Titlebar Buttons
    kwin.titlebarButtons = {
      left = [
        "more-window-actions" # Window menu
        "on-all-desktops" # Pin
      ];
      right = [
        "minimize"
        "maximize"
        "close"
      ];
    };

    # Icons
    #workspace.iconTheme = null; # Breeze, Breeze Dark (Static; No theme switch)

    # Cursors
    workspace.cursor = {
      # Configure Launch Feedback...
      #cursorFeedback = "Bouncing"; # None, Static, Blinking, Bouncing
      #taskManagerFeedback = true;
      #animationTime = 5;

      # Size & Theme
      size = stylix.cursor.size;
      theme = stylix.cursor.name; # breeze_cursors (dark), Breeze_Light
    };

    # System Sounds
    #workspace.soundTheme = "ocean"; # ocean, freedesktop

    # Splash Screen
    workspace.splashScreen = {
      #engine = "KSplashQML"; # KSplashQML, none
      #theme = "org.kde.breeze.desktop"; # org.kde.breeze.desktop, None
    };
  };
}
