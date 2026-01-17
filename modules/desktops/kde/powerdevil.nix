{
  lib,
  flk,
}:
{
  # System Settings -> Power Management -> Advanced Power Settings...
  general.pausePlayersOnSuspend = true;

  # System Settings -> Power Management
  AC = {
    autoSuspend = {
      #action = "sleep"; # nothing, sleep, hibernate, shutdown
      #idleTimeout = 900; # Seconds
    };
    #powerButtonAction = "showLogoutScreen"; # nothing, sleep, hibernate, shutDown, lockscreen, showLogoutScreen, turnOffScreen
    #whenSleepingEnter = "standby"; # standby, hybridSleep, standbyThenHibernate

    turnOffDisplay = {
      #idleTimeout = 600; # Seconds: 30-600000
      idleTimeoutWhenLocked = 30; # Seconds: 20-600000
    };

    powerProfile = "performance"; # powerSaving, balanced, performance
  };
}
// lib.optionalAttrs (flk.host.isLaptop) {
  batteryLevels = {
    lowLevel = 15;
    #criticalLevel = 5;
    criticalAction = "hibernate"; # nothing, sleep, hibernate, shutDown
  };

  AC = {
    #whenLaptopLidClosed = "sleep"; # doNothing, lockScreen, turnOffScreen, sleep, hibernate, shutDown
    #inhibitLidActionWhenExternalMonitorConnected = false;

    #displayBrightness = 70; # 0-100
    dimDisplay = {
      #enable = true;
      #idleTimeout = 300; # Seconds: 20-600000
    };
    #dimKeyboard.enable = false;
    #keyboardBrightness = 50; # 0-100
  };

  battery = {
    autoSuspend = {
      #action = "sleep";
      #idleTimeout = 600;
    };
    #powerButtonAction = "showLogoutScreen";
    whenSleepingEnter = "hybridSleep"; # standby, hybridSleep, standbyThenHibernate
    #whenLaptopLidClosed = "sleep";
    #inhibitLidActionWhenExternalMonitorConnected = false;

    #displayBrightness = 70;
    dimDisplay = {
      #enable = true;
      #idleTimeout = 120;
    };
    turnOffDisplay = {
      #idleTimeout = 300;
      idleTimeoutWhenLocked = 20;
    };
    #dimKeyboard.enable = false;
    #keyboardBrightness = 50; # 0-100

    powerProfile = "balanced"; # powerSaving, balanced, performance
  };

  lowBattery = {
    autoSuspend = {
      #action = "sleep";
      #idleTimeout = 300;
    };
    #powerButtonAction = "showLogoutScreen";
    whenSleepingEnter = "standbyThenHibernate"; # standby, hybridSleep, standbyThenHibernate
    #whenLaptopLidClosed = "sleep";
    #inhibitLidActionWhenExternalMonitorConnected = false;

    #displayBrightness = 30;
    dimDisplay = {
      enable = true;
      idleTimeout = 30;
    };
    turnOffDisplay = {
      #idleTimeout = 120;
      idleTimeoutWhenLocked = "immediately";
    };
    dimKeyboard.enable = true;
    keyboardBrightness = 0;

    powerProfile = "powerSaving"; # powerSaving, balanced, performance
  };
}
