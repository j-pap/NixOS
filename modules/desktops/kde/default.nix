{
  config,
  lib,
  pkgs,
  extraLibs,
  flk,
  ...
}:
let
  cfg = config.flake.de.kde;
  stylix = config.stylix;
  profileImg = ../../../base/profile.png;
  dockApps = [
    "applications:${flk.terminal}.desktop"
    "applications:org.kde.dolphin.desktop"
    "applications:${flk.browser}.desktop"
    "applications:thunderbird.desktop"
    "applications:discord.desktop"
    "applications:steam.desktop"
  ];
  theme = {
    dark = "org.kde.breezedark.desktop";
    light = "org.kde.breeze.desktop";
  };
in
{
  imports = [ ./fonts.nix ]; # Override HM fonts for sub-pixel rendering to be on by default

  options.flake.de.kde = {
    enable = lib.mkEnableOption "KDE Plasma Desktop Environment";
    gpuWidget = lib.mkOption {
      default = null;
      description = "The nested path of the widget's sensor details. Path can be found within '.config/plasma-org.kde.plasma.desktop-appletsrc'";
      example = "gpu/gpu0/temperature";
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf (cfg.enable) {
    flake.terminal = lib.mkDefault "konsole";

    environment = {
      plasma6.excludePackages = [ ];

      systemPackages = [
        stylix.cursor.package
        #stylix.icons.package
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # Multimedia
          haruna # MPV frontend

          # SDDM
          sddm-astronaut # Theme
          ;
        inherit (pkgs.kdePackages)
          # KDE
          krohnkite # Tiling extension for KWin
          sddm-kcm # SDDM settings module
          ;
      };
    };

    nixpkgs.overlays = [
      (final: prev: {
        # https://github.com/Keyitdev/sddm-astronaut-theme/blob/master/README.md
        sddm-astronaut = prev.sddm-astronaut.override {
          embeddedTheme = "astronaut";
          themeConfig = {
            ### General ###
            ScreenWidth = lib.toInt flk.host.monitor.width;
            ScreenHeight = lib.toInt flk.host.monitor.height;

            ### Background ###
            Background = "${flk.host.wallpaper.login}";

            ### Form ###
            #PartialBlur = false; # Form is blurred
            FullBlur = true; # Everything is blurred
            BlurMax = 64; # Default 48 | 2 - 64
            Blur = 1.0; # Default 2.0 | 0.0 - 3.0
            FormPosition = "left"; # left, center, right

            ### Interface Behavior ###
            HideVirtualKeyboard = true;
          };
        };
      })
    ];

    programs = {
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };

    services = {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };
      displayManager.sddm = {
        enable = true;
        extraPackages = builtins.attrValues {
          # Additional required packages via theme buildInputs
          inherit (pkgs.kdePackages)
            qtmultimedia
            qtsvg
            #qtvirtualkeyboard
            ;
        };
        settings.Theme = {
          CursorSize = stylix.cursor.size;
          CursorTheme = stylix.cursor.name;
        };
        theme = "sddm-astronaut-theme";
        wayland.enable = true;
      };
    };

    stylix.fonts = {
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 14;
      };
    };

    # Workaround to display profile image on SDDM
    system.activationScripts.showProfileImage.text = ''
      mkdir -p /var/lib/AccountsService/{icons,users}
      cp /home/${flk.user}/.face /var/lib/AccountsService/icons/${flk.user}
      echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${flk.user}\n" > /var/lib/AccountsService/users/${flk.user}
    '';

    systemd.packages = lib.optional (config.services.flatpak.enable) [
      pkgs.kdePackages.discover # Flatpak store
    ];

    home-manager.users.${flk.user} = {
      home.file = {
        ".face".source = profileImg; # Sets profile image
      };

      programs = {
        plasma = {
          enable = true;
          #overrideConfig = true; # If true, resets all KDE settings not defined in this module

          desktop.mouseActions.verticalScroll = "switchVirtualDesktop";
          kwin.borderlessMaximizedWindows = true;
          windows.allowWindowsToRememberPositions = false;

          panels = [
            (import ./panel-top.nix { inherit lib cfg flk; })
            (import ./panel-bottom.nix { inherit dockApps; })
          ];

          # System Settings -> Keyboard -> Shortcuts
          hotkeys.commands = import ./hotkeys.nix { inherit flk; };
          krunner.shortcuts = {
            launch = [
              "Search"
              #"Alt+F2"
              #"Alt+Space"
              "Meta+Space"
            ];
            runCommandOnClipboard = [
              #"Alt+Shift+F2"
            ];
          };
          spectacle.shortcuts = {
            captureActiveWindow = [
              #"Meta+Print"
              "Alt+Print"
            ];
            captureCurrentMonitor = null;
            captureEntireDesktop = [
              #"Shift+Print"
              "Print"
            ];
            captureRectangularRegion = [
              #"Meta+Shift+Print"
              "Shift+Print"
            ];
            captureWindowUnderCursor = [
              #"Meta+Ctrl+Print"
            ];
            launch = [
              #"Print"
              "Meta+Shift+S"
            ];
            launchWithoutCapturing = [ ];
            recordRegion = [
              #"Meta+R"
              #"Meta+Shift+R"
            ];
            recordScreen = [
              #"Meta+Alt+R"
            ];
            recordWindow = [
              #"Meta+Ctrl+R"
            ];
          };
          # Applications/System Services
          shortcuts = import ./shortcuts.nix;

          # System Settings -> Sound
          configFile.plasmaparc.General.AudioFeedback = false; # Configure Volume Controls... -> Play audio feedback for changes

          # System Settings -> Display & Monitor
          configFile.kwinrc.Xwayland.Scale = extraLibs.toFloat flk.host.monitor.scale; # Display Configuration -> Scale
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

          # System Settings -> Accessibility
          # Zoom & Magnifier
          kwin.effects.zoom = {
            enable = lib.mkDefault true;
            #pixelGridZoom = 15.0;
            #mousePointer = "scale"; # scale, keep, hide
            #mouseTracking = "proportional"; # proportional, centered, push, disabled
            #textCursorTracking.enable = false;
            #scrollGestureModKeys = "Meta+Control"; # Ctrl is spelled out here
            #focusTracking.enable = null; # ???
          };
          kwin.effects.magnifier = {
            #enable = lib.mkDefault false;
            #width = 200;
            #height = 200;
          };
          #kwin.effects.zoom.zoomFactor = 1.20;
          # Invert
          #kwin.effects.invert.enable = false;
          # Shake Cursor
          #kwin.effects.shakeCursor.enable = true;

          # System Settings -> Wallpaper
          #workspace.wallpaper = "/home/${flk.user}/.local/share/wallpapers/${config.networking.hostName}/";
          /*
            workspace.wallpaperPictureOfTheDay = {
              provider = "bing"; # null, “apod”, “bing”, “flickr”, “natgeo”, “noaa”, “wcpotd”, “epod”, “simonstalenhag”
              #updateOverMeteredConnection = false;
            };
          */
          #workspace.wallpaperFillMode = "preserveAspectCrop"; # preserveAspectCrop, stretch, preserveAspectFit, pad, tile
          /*
            workspace.wallpaperBackground = {
              # How empty space is handled with "pad" fill (centered)
              #blur = false;
              #color = "255,255,255";
            };
          */

          # System Settings -> Colors & Themes
          # Global Theme -> Switch to Dark Mode at Night
          configFile.kdeglobals.KDE = {
            AutomaticLookAndFeel = true;
            AutomaticLookAndFeelOnIdle = false;
            #DefaultDarkLookAndFeel = theme.dark; # org.kde.breezedark.desktop
            #DefaultLightLookAndFeel = theme.light; # org.kde.breeze.desktop, org.kde.breeze.desktop
          };
          workspace = {
            #lookAndFeel = null; # org.kde.breeze.desktop, org.kde.breezedark.desktop, org.kde.breezetwilight.desktop
            #colorScheme = null; # BreezeClassic, BreezeDark, BreezeLight
            #widgetStyle = "breeze"; # breeze, fusion, windows
            #theme = null; # breeze-dark, breeze-light
            windowDecorations = {
              #library = "org.kde.breeze";
              #theme = "Breeze";
            };
          };
          # Window Decorations -> Configure Titlebar Buttons
          kwin.titlebarButtons = {
            left = [
              "more-window-actions" # Windows menu
              "on-all-desktops" # Pin
            ];
            right = [
              "minimize"
              "maximize"
              "close"
            ];
          };
          #workspace.iconTheme = null; # Breeze, Breeze Dark
          workspace.cursor = {
            theme = stylix.cursor.name; # breeze_cursors, Breeze_Light
            size = stylix.cursor.size;
            # Configure Launch Feedback...
            #cursorFeedback = "Bouncing"; # None, Static, Blinking, Bouncing
            #taskManagerFeedback = true;
            #animationTime = 5;
          };
          #workspace.soundTheme = "ocean"; # ocean, freedesktop
          workspace.splashScreen = {
            #engine = "KSplashQML"; # KSplashQML, none
            #theme = "org.kde.breeze.desktop"; # org.kde.breeze.desktop, None
          };

          # System Settings -> Text & Fonts
          /*
            fonts = {
              fixedWidth = {
                family = "Hack";
                pointSize = 13;
              };
              general = {
                family = "Noto Sans";
                pointSize = 10;
              };
              small = {
                family = "Noto Sans";
                pointSize = 8;
              };
              toolbar = { };
              menu = { };
              windowTitle = { };
            };
            configFile.kdeglobals.General = {
              XftAntialias = true;
              XftHintStyle = "hintslight";
              XftSubPixel = "rgb";
            };
          */

          # System Settings -> Animations
          #kwin.effects.windowOpenClose.animation = "scale"; # off, fade, glide, scale
          kwin.effects.minimization = {
            #animation = "squash"; # off, magiclamp, squash
            #duration = 250; # magiclamp only
          };

          # System Settings -> Window Management
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
            [
              {
                description = "1Password";
                match = {
                  window-class = {
                    type = "exact";
                    value = "1password";
                    match-whole = false;
                  };
                  window-types = [ "normal" ];
                };
                apply = {
                  size = {
                    apply = "force";
                    value = "${resize flk.host.monitor.width 0.5},${resize flk.host.monitor.height 0.6}";
                  };
                  placement = {
                    apply = "force";
                    value = 1; # default/centered
                  };
                };
              }
            ];
          # KWin Scripts
          configFile.kwinrc = {
            Plugins.krohnkiteEnabled = true;
            Script-krohnkite = {
              # Layouts
              tileLayoutOrder = 1;
              monocleLayoutOrder = 2;
              threeColumnLayoutOrder = 0;
              spiralLayoutOrder = 0;
              quarterLayoutOrder = 3;
              quarterLayoutReset = true;
              stackedLayoutOrder = 0;
              columnsLayoutOrder = 4;
              spreadLayoutOrder = 0;
              floatingLayoutOrder = 5;
              stairLayoutOrder = 0;
              binaryTreeLayoutOrder = 6;
              cascadeLayoutOrder = 0;
              # Geometry
              screenGapTop = 10;
              screenGapLeft = 10;
              screenGapBetween = 10;
              screenGapRight = 10;
              screenGapBottom = 10;
              # Rules
              floatingClass = "1password";
              # Options
              soleWindowNoBorders = true;
              soleWindowNoGaps = true;
              layoutPerActivity = false;
              layoutPerDesktop = false;
              noTileBorder = true;
              preventMinimize = true;
            };
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

          # System Settings -> General Behavior
          #workspace.tooltipDelay = null; # ???
          #workspace.clickItemTo = "select"; # open, select

          # System Settings -> Search
          configFile.baloofilerc."Basic Settings".Indexing-Enabled = false; # File Search -> File indexing
          # System Settings -> Search -> Plasma Search
          # Configure KRunner...
          krunner = {
            position = "center"; # center or top
            activateWhenTypingOnDesktop = false;
            historyBehavior = "disabled"; # disabled, enableSuggestions, enableAutoComplete
          };
          configFile.krunnerrc.Plugins.baloosearchEnabled = false; # File Search
          # Web Search Keywords -> Configure
          configFile.kuriikwsfilterrc.General = {
            #EnableWebShortcuts = true;
            #UsePreferredWebShortcutsOnly = false;
            #PreferredWebShortcuts = "google,wikipedia,yahoo,youtube";
            DefaultWebShortcut = "sp";
            #KeywordDelimiter = ":";
          };

          # System Settings -> Screen Locking
          kscreenlocker = {
            # Configure Appearance...
            appearance = {
              #alwaysShowClock = true;
              #showMediaControls = true;
              #wallpaper = null;
              wallpaperPictureOfTheDay = {
                provider = "apod"; # null, “apod”, “bing”, “flickr”, “natgeo”, “noaa”, “wcpotd”, “epod”, “simonstalenhag”
                #updateOverMeteredConnection = false;
              };
              #wallpaperPlainColor = null;
              #wallpaperSlideShow = null;
            };
            #autoLock = true;
            #timeout = 5; # Minutes
            #lockOnResume = true;
            #passwordRequired = true;
            #passwordRequiredDelay = 5; # Seconds
          };

          # System Settings -> KDE Wallet
          configFile.kwalletrc.Wallet."First Use" = false;

          # System Settings -> Recent Files
          configFile.kactivitymanagerd-pluginsrc."Plugin-org.kde.ActivityManager.Resources.Scoring".keep-history-for =
            1; # Keep history
          configFile.kactivitymanagerdrc.Plugins."org.kde.ActivityManager.ResourceScoringEnabled" = false; # Remember opened documents

          # System Settings -> Power Management
          powerdevil = import ./powerdevil.nix { inherit lib flk; };

          # System Settings -> Session -> Desktop Session
          session = {
            #general.askForConfirmationOnLogout = true;
            sessionRestore = {
              restoreOpenApplicationsOnLogin = "startWithEmptySession"; # onLastLogout, whenSessionWasManuallySaved, startWithEmptySession
              #excludeApplications = [ ]; # null or list of strings
            };
          };

          configFile = {
            # Dolphin -> Interface -> Folders & Tabs -> Show on startup
            dolphinrc.General = {
              RememberOpenedTabs = false;
              HomeUrl = "/home/${flk.user}";
            };
            # Dolphin -> Interface -> Previews
            kdeglobals.PreviewSettings = {
              MaximumRemoteSize = 20971520; # Remote storage: 20 MiB
              EnableRemoteFolderThumbnail = true; # Show previews for folders
            };
            # Dolphin -> Interface -> Confirmations
            kiorc = {
              Confirmations = {
                #ConfirmTrash = false;
                #ConfirmEmptyTrash = true;
                #ConfirmDelete = true;
              };
              #"Executable scripts".behaviourOnLaunch = "alwaysAsk";
            };
            # Dolphin -> Trash
            ktrashrc."\\/home\\/${flk.user}\\/.local\\/share\\/Trash" = {
              UseTimeLimit = true;
              Days = 30;
              #UseSizeLimit = true;
              Percent = 5;
              #LimitReachedAction = 0; # 0 (warning), 1 (oldest), 2 (biggest)
            };
          };
        };
      };

      services.darkman =
        let
          plasma = {
            lookandfeel = lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-lookandfeel";
            wallpaper = lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-wallpaperimage";
            changeicons = "${pkgs.kdePackages.plasma-workspace}/libexec/plasma-changeicons";
            cursor = lib.getExe' pkgs.kdePackages.plasma-workspace "plasma-apply-cursortheme";
          };
        in
        {
          enable = true;
          darkModeScripts = {
            kitty = ''
              ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.dark}.conf /home/${flk.user}/.config/kitty/current-theme.conf
              kill -SIGUSR1 $(pidof kitty) 2>/dev/null
            '';
            plasma_theme = ''
              ${plasma.lookandfeel} --keep-auto --apply ${theme.dark} && \
                ${plasma.cursor} ${stylix.cursor.name}
              #${plasma.wallpaper} ${flk.host.wallpaper.dark}
              #${plasma.changeicons} ${stylix.icons.dark}
            '';
          };

          lightModeScripts = {
            kitty = ''
              ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.light}.conf /home/${flk.user}/.config/kitty/current-theme.conf
              kill -SIGUSR1 $(pidof kitty) 2>/dev/null
            '';
            plasma_theme = ''
              ${plasma.lookandfeel} --keep-auto --apply ${theme.light} && \
                ${plasma.cursor} ${stylix.cursor.name}
              #${plasma.wallpaper} ${flk.host.wallpaper.light}
              #${plasma.changeicons} ${stylix.icons.light}
            '';
          };
        };

      xdg = {
        configFile =
          let
            hwDecoder =
              if (flk.hw.amdgpu.enable) then
                "vaapi"
              else if (flk.hw.nvidia.enable) then
                "nvdec"
              else
                "auto";
          in
          {
            # Set Haruna settings
            "haruna/haruna.conf".text = ''
              [General]
              MaxRecentFiles=0

              [Playback]
              UseHWDecoding=true
              HWDecoding=${hwDecoder}

              [Playlist]
              CanToggleWithMouse=false
              LoadSiblings=false
              Repeat=false
            '';

            # Set Haruna keybinds
            "haruna/shortcuts.conf".text = ''
              [Shortcuts]
              seekBackwardBigAction=
              seekForwardBigAction=
              volumeDownAction=Down
              volumeUpAction=Up
            '';
          };

        # Host-specific dynamic wallpaper
        dataFile =
          let
            host = config.networking.hostName;
            width = flk.host.monitor.width;
            height = flk.host.monitor.height;
            wall = flk.host.wallpaper;
          in
          {
            "wallpapers/${host}/contents/images/${width}x${height}.png".source = wall.light;
            "wallpapers/${host}/contents/images_dark/${width}x${height}.png".source = wall.dark;
            "wallpapers/${host}/metadata.json".text = ''
              {
                  "KPlugin": {
                      "Id": "${host}",
                      "Name": "Flake"
                  }
              }
            '';
          }
          // import ./krunner-web.nix; # KRunner web search providers

        # Set default application file associations
        mimeApps =
          let
            mime = {
              archive = [ "org.kde.ark.desktop" ];
              audio = [ "org.kde.elisa.desktop" ];
              browser = [ "${flk.browser}.desktop" ];
              calendar = [ "thunderbird.desktop" ];
              connect = [ "org.kde.kdeconnect.sms.desktop" ];
              email = [ "thunderbird.desktop" ];
              files = [ "org.kde.dolphin.desktop" ];
              image = [ "org.kde.gwenview.desktop" ];
              pdf = [ "org.kde.okular.desktop" ];
              text = [
                "nvim.desktop"
                "org.kde.kate.desktop"
              ];
              video = [ "org.kde.haruna.desktop" ];
            };
          in
          {
            enable = true;
            defaultApplications = import ../mimeapps.nix { inherit mime; };
          };
      };
    };
  };
}
