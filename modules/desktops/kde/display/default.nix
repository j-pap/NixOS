{
  extraLibs,
  flk,
  ...
}:
{
  # System Settings -> Display & Monitor
  programs.plasma = {
    # Display Configuration -> Scale
    configFile.kwinrc.Xwayland.Scale = extraLibs.toFloat flk.host.monitor.scale;

    # Night Light
    kwin.nightLight = {
      enable = true;
      #mode = "location"; # constant, location, times
      location = {
        #latitude = null;
        #longitude = null;
      };
      time = {
        #morning = "08:00";
        #evening = "17:00";
      };
      #transitionTime = 30; # Minutes
      temperature = {
        day = 6500;
        night = 5500;
      };
    };

    # Screen Edges
    configFile.kwinrc = {
      Effect-overview.BorderActivate = 0; # Top Center - Overview
      ElectricBorders = {
        TopLeft = "ApplicationLauncher";
        TopRight = "ShowDesktop";
      };
      Windows = {
        ElectricBorderDelay = 150; # Activation delay
        ElectricBorderCooldown = 225; # Reactivation delay
      };
    };
    #kwin.cornerBarrier = true;
    #kwin.edgeBarrier = 100;
  };
}
