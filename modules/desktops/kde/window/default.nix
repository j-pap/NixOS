{
  lib,
  extraLibs,
  flk,
}:
{
  # System Settings -> Window Management
  programs.plasma = {
    # Window Behavior -> Focus -> Window activation policy
    configFile.kwinrc.Windows.FocusPolicy = "FocusFollowsMouse";

    # Desktop Effects
    kwin.effects = {
      #fps.enable = null; # ???
      #snapHelper.enable = null; # ???
      # Accessibility
      hideCursor = {
        enable = true;
        #hideOnInactivity = 0; # Seconds
        #hideOnTyping = true;
      };
      # Appearance
      blur = {
        #enable = true;
        #strength = 14;
        #noiseStrength = 5;
      };
      #fallApart.enable = false;
      #translucency.enable = false;
      #wobblyWindows.enable = false;
      # Focus
      #dimInactive.enable = false;
      #dimAdminMode.enable = true;
      #slideBack.enable = false;
      # Window Management
      #cube.enable = false;
    };

    # Window Rules
    window-rules =
      let
        resize = s: f: toString (extraLibs.truncateFloat ((lib.toInt s) * f) 0);
      in
      import ./window-rules.nix { inherit flk resize; };

    # KWin Scripts
    configFile.kwinrc = {
      Plugins.krohnkiteEnabled = true;
      Script-krohnkite = import ./krohnkite-settings.nix;
    };

    # Virtual Desktops
    kwin.virtualDesktops = {
      rows = 1;
      names = [
        "Desktop 1"
        "Desktop 2"
        "Desktop 3"
        "Desktop 4"
      ];
      #number = 4; # If names is defined, that length is used
    };
    kwin.effects.desktopSwitching = {
      #navigationWrapping = false;
      #animation = "slide"; # fade, slide, off
    };
  };
}
