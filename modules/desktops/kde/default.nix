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
  ]
  ++ lib.optionals (flk.gaming.enable) [
    "applications:steam.desktop"
  ];
  theme = {
    dark = "org.kde.breezedark.desktop";
    light = "org.kde.breeze.desktop";
  };
in
{
  imports = [ ./fonts/hm.nix ]; # Override HM fonts for sub-pixel rendering to be on by default

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

    programs = {
      kdeconnect.enable = true;
      partition-manager.enable = true;
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

    services = {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings.Theme = {
          CursorSize = stylix.cursor.size;
          CursorTheme = stylix.cursor.name;
        };
        theme = "sddm-astronaut-theme";
        extraPackages = builtins.attrValues {
          # Additional packages required by theme's buildInputs
          inherit (pkgs.kdePackages)
            qtmultimedia
            qtsvg
            #qtvirtualkeyboard
            ;
        };
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

    systemd.packages = lib.optionals (config.services.flatpak.enable) [
      pkgs.kdePackages.discover # Flatpak store
    ];

    home-manager.users.${flk.user} = {
      imports = [
        (import ./keyboard { inherit flk; })
        (import ./display { inherit extraLibs flk; })
        (import ./accessibility { inherit lib; })
        (import ./wallpaper { inherit config flk; })
        (import ./themes { inherit stylix theme; })
        #./fonts
        (import ./window { inherit lib extraLibs flk; })
        ./search
      ];

      home.file.".face".source = profileImg; # Sets profile image

      programs = {
        plasma = {
          enable = true;
          #overrideConfig = true; # If true, resets all KDE settings not defined in this module

          desktop.mouseActions.verticalScroll = "switchVirtualDesktop";
          kwin.borderlessMaximizedWindows = true;
          windows.allowWindowsToRememberPositions = false;

          panels = [
            (import ./panels/panel.nix { inherit lib cfg flk; })
            (import ./panels/dock.nix { inherit dockApps; })
          ];

          # System Settings -> Sound
          configFile.plasmaparc.General.AudioFeedback = false; # Configure Volume Controls... -> Play audio feedback for changes

          # System Settings -> Animations
          #kwin.effects.windowOpenClose.animation = "scale"; # off, fade, glide, scale
          kwin.effects.minimization = {
            #animation = "squash"; # off, magiclamp, squash
            #duration = 250; # magiclamp only
          };

          # System Settings -> General Behavior
          #workspace.tooltipDelay = null; # ???
          #workspace.clickItemTo = "select"; # open, select

          # System Settings -> Screen Locking
          kscreenlocker = import ./locker;

          # System Settings -> KDE Wallet
          configFile.kwalletrc.Wallet."First Use" = false;

          # System Settings -> Recent Files
          configFile.kactivitymanagerd-pluginsrc."Plugin-org.kde.ActivityManager.Resources.Scoring".keep-history-for =
            1; # Keep history
          configFile.kactivitymanagerdrc.Plugins."org.kde.ActivityManager.ResourceScoringEnabled" = false; # Remember opened documents

          # System Settings -> Power Management
          powerdevil = import ./power { inherit lib flk; };

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
