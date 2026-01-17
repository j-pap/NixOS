{
  lib,
  cfg,
  flk,
}:
{
  location = "top"; # top, bottom, left, right, floating
  alignment = "center"; # left, center, right
  lengthMode = "fill"; # fill, fit, custom
  hiding = "normalpanel"; # normalpanel, autohide, dodgewindows, windowsgobelow
  opacity = "adaptive"; # adaptive, opaque, translucent
  floating = true;
  height = 46;
  widgets = [
    {
      kickoff = {
        icon = "nix-snowflake";
        label = null;
        sortAlphabetically = true;
        compactDisplayStyle = false;
        sidebarPosition = "left";
        favoritesDisplayMode = "grid";
        applicationsDisplayMode = "list";
        showButtonsFor = "power";
        showActionButtonCaptions = false;
      };
    }
    {
      pager.general = {
        showWindowOutlines = true;
        showApplicationIconsOnWindowOutlines = true;
        showOnlyCurrentScreen = true;
        navigationWrapsAround = false;
        displayedText = "none"; # none, desktopNumber, desktopName
        selectingCurrentVirtualDesktop = "doNothing"; # doNothing, showDesktop
      };
    }
    "org.kde.plasma.marginsseparator"
    {
      plasmusicToolbar = {
        panelIcon = {
          icon = "view-media-track";
          albumCover = {
            fallbackToIcon = true;
            useAsIcon = true;
            radius = 10;
          };
        };
        playbackSource = "auto";
        songText = {
          maximumWidth = 150;
          scrolling = {
            enable = true;
            behavior = "alwaysScrollExceptOnHover";
            speed = 2;
            resetOnPause = true;
          };
          displayInSeparateLines = true;
        };
        musicControls = {
          showPlaybackControls = true;
          volumeStep = 5;
        };
      };
    }
    {
      panelSpacer.expanding = true;
    }
    "org.kde.plasma.weather"
    "org.kde.plasma.marginsseparator"
    {
      digitalClock = {
        date = {
          enable = true;
          format = "shortDate"; # longDate, shortDate, isoDate
          position = "belowTime"; # adaptive, besideTime, belowTime
        };
        time = {
          showSeconds = "onlyInTooltip"; # never, onlyInTooltip, always
          format = "24h"; # 12h, default, 24h
        };
        calendar = {
          showWeekNumbers = false;
          firstDayOfWeek = "sunday";
          #plugins = [ ];
        };
        timeZone = {
          selected = [
            "America/Chicago"
            "Asia/Tokyo"
            "Europe/Tallinn"
            "Pacific/Auckland"
          ];
          lastSelected = "Local";
          alwaysShow = false;
          changeOnScroll = true;
          format = "offset"; # code, city, offset
        };
      };
    }
    {
      panelSpacer.expanding = true;
    }
    {
      systemMonitor = {
        title = "CPU/GPU Temperature";
        showTitle = true;
        displayStyle = "org.kde.ksysguard.textonly";
        sensors = [
          {
            name = "cpu/all/averageTemperature";
            color = "125,60,235";
            label = "C";
          }
        ]
        ++ lib.optionals (cfg.gpuWidget != null) [
          {
            name = "${cfg.gpuWidget}";
            color = "0,200,0";
            label = "G";
          }
        ];
      };
    }
    {
      systemTray = {
        icons = {
          spacing = "medium"; # small, medium, large
          scaleToFit = false;
        };
        items = {
          shown = [
            "org.kde.plasma.volume"
          ]
          ++ lib.optionals (flk.hw.bluetooth.enable) [
            "blueman"
          ]
          ++ [
            "org.kde.plasma.networkmanagement"
            "org.kde.plasma.battery"
          ];
          configs = {
            battery.showPercentage = true;
          };
          hidden = [
            "org.kde.plasma.bluetooth"
            "org.kde.plasma.brightness"
            "org.kde.plasma.clipboard"
            "org.kde.plasma.mediacontroller"
          ];
        };
      };
    }
  ];
}
