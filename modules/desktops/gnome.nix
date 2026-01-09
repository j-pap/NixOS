{
  config,
  lib,
  pkgs,
  browser,
  flk,
  myUser,
  terminal,
  ...
}:
let
  cfg = config.flake.de.gnome;
  stylix = config.stylix;
  logoImg = ../../assets/logo.png;
  profileImg = ../../assets/profile.png;
in
{
  options.flake.de.gnome.enable = lib.mkEnableOption "GNOME Desktop Environment";

  # GNOME v49.X
  config = lib.mkIf (cfg.enable) {
    environment = {
      gnome.excludePackages = builtins.attrValues {
        inherit (pkgs)
          #decibals             # Audio player
          #gnome-calculator     # Calculator
          #gnome-calendar       # Calendar
          #snapshot             # Camera
          #gnome-characters     # Character map
          #gnome-clocks         # Clock
          gnome-connections     # Connections (RDP/VNC)
          #gnome-console        # Console
          #gnome-contacts       # Contacts
          #baobab               # Disk usage
          #gnome-disk-utility   # Disks
          #simple-scan          # Document scanner
          #papers               # Document viewer
          #nautilus             # Files
          #gnome-font-viewer    # Font viewer
          yelp                  # Help
          #loupe                # Image viewer
          #gnome-logs           # Log viewer
          #gnome-maps           # Maps
          #gnome-music          # Music
          #gnome-software       # Software (Flatpak)
          #gnome-system-monitor # System monitor
          #gnome-text-editor    # Text editor
          gnome-tour            # Tour
          #showtime             # Video player
          #gnome-weather        # Weather
          epiphany              # Web browser
          ;
      };

      systemPackages = [
        stylix.cursor.package # GDM
        #] ++ lib.optionals (terminal != "kgx") [
        pkgs.nautilus-python            # Allow custom nautilus scripts/open-any-terminal
        pkgs.nautilus-open-any-terminal # Open custom terminals in nautilus
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # GNOME
          dconf-editor            # GUI dconf editor
          file-roller             # Archive manager
          gnome-extension-manager # Extensions
          gnome-tweaks            # Tweaks

          # GNOME Circle
          amberol     # Music player
          eyedropper  # Color picker

          # Multimedia
          celluloid # GTK MPV frontend w/ Wayland
          ;
      };

      variables.TERMINAL = lib.mkDefault "kgx"; # GNOME terminal
    };

    nixpkgs.overlays = [
      (final: prev: {
        # Display audio/video properties
        nautilus = prev.nautilus.overrideAttrs (super: {
          buildInputs =
            super.buildInputs
            ++ builtins.attrValues {
              inherit (prev.gst_all_1)
                gstreamer
                gst-libav
                #gst-plugins-base # Already included w/ super.buildInputs
                gst-plugins-good
                #gst-plugins-bad
                #gst-plugins-ugly
                gst-vaapi
                ;
            };
        });
      })
    ];

    programs = {
      dconf.profiles.gdm.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              cursor-size = lib.gvariant.mkInt32 stylix.cursor.size;
              cursor-theme = stylix.cursor.name;
            };
            "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
            "org/gnome/login-screen".logo = toString logoImg;
            "org/gnome/mutter".experimental-features = [
              "scale-monitor-framebuffer"
              "variable-refresh-rate"
              "xwayland-native-scaling"
            ];
          };
        }
      ];

      kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
    };

    security.pam.services.gdm.enableGnomeKeyring = true; # Unlock keyring upon login

    services = {
      desktopManager.gnome = {
        enable = true;
        debug = true;
      };
      displayManager.gdm = {
        enable = true;
        debug = true;
      };

      gnome = {
        gcr-ssh-agent.enable = lib.mkIf (flk.git.ssh.enable && flk."1password".enable) false;
        rygel.enable = false;
      };
    };

    stylix = {
      fonts = {
        monospace = {
          name = "Adwaita Mono Regular";
          package = pkgs.adwaita-fonts;
        };
        sansSerif = {
          name = "Adwaita Sans Regular";
          package = pkgs.adwaita-fonts;
        };
        sizes = {
          applications = 11;
          desktop = 11;
          popups = 11;
          terminal = 15;
        };
      };
      icons = {
        package = pkgs.adwaita-icon-theme;
        dark = "Adwaita";
        light = "Adwaita";
      };
      targets = {
        gnome.enable = false;
        #gnome-text-editor.enable = true; # Throws assertion about nixpkgs/useGlobalPkgs
      };
    };

    # Workaround to display profile image on GDM
    system.activationScripts.showProfileImage.text = ''
      mkdir -p /var/lib/AccountsService/{icons,users}
      cp /home/${myUser}/.face /var/lib/AccountsService/icons/${myUser}
      echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${myUser}\nSession=gnome\nSystemAccount=false\n" > /var/lib/AccountsService/users/${myUser}
    '';

    home-manager.users.${myUser} =
      let
        gnomeExts =
          builtins.attrValues {
            inherit (pkgs.gnomeExtensions)
              alphabetical-app-grid
              appindicator
              bluetooth-quick-connect
              blur-my-shell
              caffeine
              clipboard-indicator
              fuzzy-app-search
              hibernate-status-button
              hot-edge
              just-perfection
              lock-keys
              night-theme-switcher
              notification-timeout
              power-profile-switcher
              search-light
              vitals
              weather-or-not
              ;
          }
          ++ lib.optionals (flk.host.isLaptop) [
            pkgs.gnomeExtensions.battery-health-charging
          ];
      in
      {
        dconf.settings = {
          # Settings->Displays
          "org/gnome/mutter".experimental-features = [
            "scale-monitor-framebuffer"
            "variable-refresh-rate"
            "xwayland-native-scaling"
          ];
          # Settings->Displays->Night Light
          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            #night-light-schedule-automatic = true;
            night-light-temperature = lib.gvariant.mkUint32 4700;
          };

          # Settings->Power->General
          #"org/gnome/settings-daemon/plugins/power".power-button-action = "suspend";
          "org/gnome/desktop/interface".show-battery-percentage = true;
          # Settings->Power->Power Saving
          "org/gnome/settings-daemon/plugins/power" = {
            #ambient-enabled = true;
            #idle-dim = true;
            #power-saver-profile-on-low-battery = true;
            sleep-inactive-battery-timeout = 600; # 10 minutes
            sleep-inactive-ac-timeout = 1800; # 30 minutes
          };

          # Settings->Multitasking
          #"org/gnome/desktop/interface".enable-hot-corners = true;
          "org/gnome/mutter" = {
            #edge-tiling = true;
            #dynamic-workspaces = true;
            workspaces-only-on-primary = false;
          };
          #"org/gnome/desktop/wm/preferences".num-workspaces = 4; # Number for fixed workspaces

          # Settings->Appearance
          "org/gnome/desktop/interface" = {
            #color-scheme = "prefer-dark"; # default or prefer-dark
            accent-color = "purple"; # blue teal green yellow orange red pink purple slate
          };

          # Settings->Mouse & Touchpad
          "org/gnome/desktop/peripherals/touchpad" = {
            #tap-to-click = true;
            #two-finger-scrolling-enabled = true;
            #natural-scroll = true;
          };

          # Settings->Keyboard->Keyboard Shortcuts
          "org/gnome/settings-daemon/plugins/media-keys" = {
            # Settings->Keyboard->Keyboard Shortcuts->Accessibility
            #decrease-text-size = [ ];
            #toggle-contrast = [ ];
            #increase-text-size = [ ];
            #on-screen-keyboard = [ ];
            screenreader = [
              #"<Alt><Super>s"
            ];
            magnifier = [
              #"<Alt><Super>8"
            ];
            magnifier-zoom-in = [
              #"<Alt><Super>equal"
            ];
            magnifier-zoom-out = [
              #"<Alt><Super>minus"
            ];

            # Settings->Keyboard->Keyboard Shortcuts->Launchers
            home = [ "<Shift><Super>f" ];
            #calculator = [ ];
            #email = [ ];
            help = [
              #"<Super>F1"
            ];
            www = [ "<Shift><Super>b" ];
            #search = [ ];
            #control-center = [ ];

            # Settings->Keyboard->Keyboard Shortcuts->Sound and Media
            #eject = [ ];
            #media = [ ];
            #mic-mute = [ ];
            #next = [ ];
            #pause = [ ];
            #play = [ ];
            #previous = [ ];
            #stop = [ ];
            #volume-down = [ ];
            #volume-mute = [ ];
            #volume-up = [ ];

            # Settings->Keyboard->Keyboard Shortcuts->System
            screensaver = [
              #"<Super>l"
              "<Super><Shift>Escape"
            ];
            #logout = [ "<Control><Alt>Delete" ];
            #power = [ ];
            #reboot = [ ];
          };
          "org/gnome/desktop/wm/keybindings" = {
            # Settings->Keyboard->Keyboard Shortcuts->Navigation
            show-desktop = [ "<Super>d" ];
            move-to-monitor-down = [
              #"<Super><Shift>Down"
              "<Shift><Alt><Super>Down"
              "<Shift><Alt><Super>j"
            ];
            move-to-monitor-left = [
              #"<Super><Shift>Left"
              "<Shift><Alt><Super>Left"
              "<Shift><Alt><Super>h"
            ];
            move-to-monitor-right = [
              #"<Super><Shift>Right"
              "<Shift><Alt><Super>Right"
              "<Shift><Alt><Super>l"
            ];
            move-to-monitor-up = [
              #"<Super><Shift>Up"
              "<Shift><Alt><Super>Up"
              "<Shift><Alt><Super>k"
            ];
            move-to-workspace-down = [
              #"<Control><Shift><Alt>Down"
            ];
            move-to-workspace-left = [
              #"<Super><Shift>Page_Up"
              "<Shift><Control><Super>Left"
              "<Shift><Control><Super>h"
            ];
            move-to-workspace-right = [
              #"<Super><Shift>Page_Down"
              "<Shift><Control><Super>Right"
              "<Shift><Control><Super>l"
            ];
            move-to-workspace-up = [
              #"<Control><Shift><Alt>Up"
            ];
            #move-to-workspace-last = [ "<Super><Shift>End" ];
            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            move-to-workspace-5 = [ "<Shift><Super>5" ];
            move-to-workspace-6 = [ "<Shift><Super>6" ];
            move-to-workspace-7 = [ "<Shift><Super>7" ];
            move-to-workspace-8 = [ "<Shift><Super>8" ];
            move-to-workspace-9 = [ "<Shift><Super>9" ];
            move-to-workspace-10 = [ "<Shift><Super>0" ];
            #switch-applications = [ "<Super>Tab" "<Alt>Tab" ];
            #switch-applications-backward = [ "<Shift><Super>Tab" "<Shift><Alt>Tab" ];
            #switch-panels = [ "<Control><Alt>Tab" ];
            #switch-panels-backward = [ "<Shift><Control><Alt>Tab" ];
            #cycle-panels = [ "<Control><Alt>Escape" ];
            #cycle-panels-backward = [ "<Shift><Control><Alt>Escape" ];
            #switch-to-workspace-last = [ "<Super>End" ];
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-5 = [ "<Super>5" ];
            switch-to-workspace-6 = [ "<Super>6" ];
            switch-to-workspace-7 = [ "<Super>7" ];
            switch-to-workspace-8 = [ "<Super>8" ];
            switch-to-workspace-9 = [ "<Super>9" ];
            switch-to-workspace-10 = [ "<Super>0" ];
            switch-to-workspace-left = [
              #"<Super>Page_Up"
              "<Control><Super>Left"
              "<Control><Super>h"
            ];
            switch-to-workspace-right = [
              #"<Super>Page_Down"
              "<Control><Super>Right"
              "<Control><Super>l"
            ];
            #switch-windows = [ ];
            #cycle-windows = [ "<Alt>Escape" ];
            #cycle-windows-backward = [ "<Shift><Alt>Escape" ];
            #cycle-group = [ "<Alt>F6" ];
            #cycle-group-backward = [ "<Shift><Alt>F6" ];
            #switch-group = [ "<Super>Above_Tab" "<Alt>Above_Tab" ];
            #switch-group-backward = [ "<Shift><Super>Above_Tab" "<Shift><Alt>Above_Tab" ];

            # Settings->Keyboard->Keyboard Shortcuts->System
            #panel-run-dialog = [ "<Alt>F2" ];

            # Settings->Keyboard->Keyboard Shortcuts->Typing
            switch-input-source = [
              #"<Super>space"
            ];
            switch-input-source-backward = [
              #"<Shift><Super>space"
            ];

            # Settings->Keyboard->Keyboard Shortcuts->Windows
            #activate-window-menu = [ "<Alt>space" ];
            close = [
              #"<Alt>F4"
              "<Super>q"
            ];
            #minimize = [ "<Super>h" ];
            #lower = [ ];
            #maximize = [ "<Super>Up" ];
            #maximize-horizontally = [ ];
            #maximize-vertically = [ ];
            #begin-move = [ "<Alt>F7" ];
            #raise = [ ];
            #raise-or-lower = [ ];
            #begin-resize = [ "<Alt>F8" ];
            #unmaximize = [ "<Super>Down" "<Alt>F5" ];
            toggle-fullscreen = [ "<Super>F11" ];
            toggle-maximized = [
              #"<Alt>F10"
              "<Super>m"
            ];
            #toggle-on-all-workspaces = [ ];
          };
          "org/gnome/shell/keybindings" = {
            # Settings->Keyboard->Keyboard Shortcuts->Screenshots
            #show-screen-recording-ui = [ "<Ctrl><Shift><Alt>R" ];
            screenshot = [
              #"<Shift>Print"
              "Print"
            ];
            show-screenshot-ui = [
              #"Print"
              "<Shift>Print"
            ];
            #screenshot-window = [ "<Alt>Print" ];

            # Settings->Keyboard->Keyboard Shortcuts->System
            #focus-active-notification = [ "<Super>n" ];
            #toggle-quick-settings = [ "<Super>s" ];
            #toggle-application-view = [ "<Super>a" ];
            toggle-message-tray = [
              "<Super>v"
              #"<Super>m"
            ];
            #toggle-overview = [ ];

            # Reassign to empty from <Super>#
            switch-to-application-1 = [ ];
            switch-to-application-2 = [ ];
            switch-to-application-3 = [ ];
            switch-to-application-4 = [ ];
            switch-to-application-5 = [ ];
            switch-to-application-6 = [ ];
            switch-to-application-7 = [ ];
            switch-to-application-8 = [ ];
            switch-to-application-9 = [ ];
          };
          "org/gnome/mutter/wayland/keybindings".restore-shortcuts = [ ];
          # Settings->Keyboard->Keyboard Shortcuts->Windows
          "org/gnome/mutter/keybindings" = {
            #toggle-tiled-left = [ "<Super>Left" ];
            #toggle-tiled-right = [ "<Super>Right" ];
            cancel-input-capture = [
              #"<Super><Shift>Escape"
            ];
          };
          # Settings->Keyboard->Keyboard Shortcuts->Custom Shortcuts
          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          ];
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>Return";
            command = terminal;
            name = "Launch Terminal";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            binding = "<Shift><Super>n";
            command = "${terminal} nvim";
            name = "Launch Neovim";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            binding = "<Shift><Super>y";
            command = "${terminal} yazi";
            name = "Launch Yazi";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
            binding = "<Shift><Super>slash";
            command = "1password --toggle";
            name = "Launch 1Password";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
            binding = "<Super>Print";
            command = "eyedropper";
            name = "Launch Color Picker";
          };
          # Settings->Keyboard->Keyboard Shortcuts->Activities Overview Shortcut
          #"org/gnome/mutter".overlay-key = "Super";

          # Settings->Privacy & Security->Screen Lock
          "org/gnome/desktop/screensaver" = {
            #lock-enabled = true;
            lock-delay = lib.gvariant.mkUint32 5;
          };
          # Settings->Privacy & Security->Location
          #"org/gnome/system/location".enabled = false;
          "org/gnome/desktop/privacy" = {
            # Settings->Privacy & Security->File History & Trash
            remember-recent-files = false;
            recent-files-max-age = 0;
            remove-old-trash-files = true;
            remove-old-temp-files = true;
            #old-files-age = lib.gvariant.mkUint32 30;
            # Settings->Privacy & Security->Cameras
            #disable-camera = false;
            # Hidden options
            #disable-microphone = false;
            report-technical-problems = false;
            send-software-usage-stats = false;
          };

          # Settings->System->Date & Time
          "org/gnome/desktop/datetime".automatic-timezone = true;
          #"org/gtk/settings/file-chooser".clock-format = "24h";
          "org/gnome/desktop/interface" = {
            #clock-format = "24h";
            clock-show-weekday = true;
            #clock-show-date = true;
          };

          # GNOME Tweaks
          # Fonts->Rendering
          "org/gnome/desktop/interface".font-antialiasing = "rgba";
          # Appearance->Styles
          #"org/gnome/desktop/interface".icon-theme = "Adwaita";
          # Appearance->Background
          #"org/gnome/desktop/background" = {
          #picture-url = "";
          #picture-url-dark = "";
          #picture-options = "zoom";
          #};
          # Mouse & Touchpad
          #"org/gnome/desktop/peripherals/touchpad".accel-profile = "default";
          # Windows
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
            mouse-button-modifier = "<Alt>";
            resize-with-right-button = true;
            focus-mode = "mouse";
          };
          #"org/gnome/mutter".center-new-windows = true;

          # Nautilus
          "org/gnome/nautilus/compression".default-compression-format = "tar.xz";
          "org/gnome/nautilus/icon-view".default-zoom-level = "small";
          "org/gnome/nautilus/list-view".default-zoom-level = "small";
          "org/gnome/nautilus/preferences" = {
            always-use-location-entry = false;
            default-folder-viewer = "list-view"; # 'icon-view' or 'list-view'
            show-create-link = true;
            show-delete-permanently = true;
          };
          "org/gtk/gtk4/settings/file-chooser".show-hidden = true;
          #"com/github/stunkymonkey/nautilus-open-any-terminal" = lib.optionalAttrs (terminal != "kgx") {
          "com/github/stunkymonkey/nautilus-open-any-terminal" = {
            terminal = terminal;
          };

          "org/gnome/Console" = {
            #custom-font = "Iosvmata 15";
            #custom-font = "${config.stylix.fonts.monospace.name} ${config.stylix.fonts.sizes.terminal}";
            ignore-scrollback-limit = true;
            #use-system-font = false;
          };

          "org/gnome/TextEditor" = {
            restore-session = false;
            show-line-numbers = true;
            tab-width = 2;
          };

          "ca/desrt/dconf-editor".show-warning = false;

          "org/gnome/shell" = {
            favorite-apps = [
              "${terminal}.desktop"
              "org.gnome.Nautilus.desktop"
              "${browser}.desktop"
              "thunderbird.desktop"
              "discord.desktop"
              "steam.desktop"
            ];

            #disable-user-extensions = false;
            enabled-extensions = (map (extension: extension.extensionUuid) gnomeExts) ++ [
              # Enable extensions that ship, but aren't enabled by default
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
            ];
          };
          "org/gnome/shell/weather".automatic-location = true;
          "org/gnome/shell/extensions/appindicator".icon-size = 16;
          "org/gnome/shell/extensions/Battery-Health-Charging" =
            let
              bal = 85;
              ful = 90;
            in
            lib.optionalAttrs (flk.host.isLaptop) {
              charging-mode = "ful";
              bal-end-threshold = bal;
              ful-end-threshold = ful;
              current-bal-end-threshold = bal;
              current-ful-end-threshold = ful;
              amend-power-indicator = true;
              indicator-position = 4;
              show-system-indicator = false;
            };
          "org/gnome/shell/extensions/bluetooth-quick-connect" = {
            bluetooth-auto-power-off = true;
            bluetooth-auto-power-off-interval = 180;
            refresh-button-on = true;
            show-battery-icon-on = true;
            show-battery-value-on = true;
          };
          "org/gnome/shell/extensions/blur-my-shell/panel" = {
            blur = true;
            static-blur = true;
            override-background = true;
            style-panel = 0; # 0: transparent, 1: light, 2: dark, 3: contrasted
            unblur-in-overview = true;
          };
          "org/gnome/shell/extensions/blur-my-shell/applications" = {
            blur = true;
            sigma = 8;
            opacity = 230; # 90%
            dynamic-opacity = false;
            blur-on-overview = true;
            whitelist = [
              "com.mitchellh.ghostty"
              "com.system76.CosmicTerm"
              "kitty"
              "org.gnome.Console"
              "org.kde.konsole"
              "org.wezfurlong.wezterm"
            ];
          };
          "org/gnome/shell/extensions/clipboard-indicator" = {
            clear-on-boot = true;
            strip-text = true;
            topbar-preview-size = 10;
          };
          "org/gnome/shell/extensions/dash-to-dock" = {
            apply-custom-theme = true;
            custom-theme-shrink = true;
            disable-overview-on-startup = true;
            hot-keys = false;
            intellihide-mode = "ALL_WINDOWS";
            scroll-action = "switch-workspace";
            show-trash = false;
          };
          "org/gnome/shell/extensions/hibernate-status-button" = {
            show-hybrid-sleep = false;
            show-suspend-then-hibernate = false;
          };
          "org/gnome/shell/extensions/just-perfection" = {
            notification-banner-position = 1; # 1=top center
            panel-button-padding-size = 3; # 3=2px
            panel-indicator-padding-size = 0; # 0=shell theme
            startup-status = 0; # 0=desktop, 1=overview
          };
          "org/gnome/shell/extensions/lockkeys".style = "show-hide-capslock";
          "org/gnome/shell/extensions/nightthemeswitcher/commands" =
            let
              switch-mode = pkgs.callPackage ../programs/stylix/switch-mode.nix { };
              themeSwitch = pkgs.writeShellScriptBin "gnome-theme-switch" ''
                CURRENT_THEME=$(gsettings get org.gnome.desktop.interface color-scheme | cut -d "'" -f 2)
                if [[ "$CURRENT_THEME" = "default" ]]; then
                  # Kitty
                  ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.light}.conf /home/${myUser}/.config/kitty/current-theme.conf
                  kill -SIGUSR1 $(pidof kitty) 2>/dev/null
                  # Wallpaper
                  gsettings set org.gnome.desktop.background picture-uri '${flk.host.wallpaper.light}'
                elif [[ "$CURRENT_THEME" = "prefer-dark" ]]; then
                  # Kitty
                  ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.dark}.conf /home/${myUser}/.config/kitty/current-theme.conf
                  kill -SIGUSR1 $(pidof kitty) 2>/dev/null
                  # Wallpaper
                  gsettings set org.gnome.desktop.background picture-uri-dark '${flk.host.wallpaper.dark}'
                fi;
              '';
            in
            {
              enabled = true;
              sunrise = if (stylix.enable) then "${lib.getExe switch-mode} light" else "${lib.getExe themeSwitch}";
              sunset = if (stylix.enable) then "${lib.getExe switch-mode} dark" else "${lib.getExe themeSwitch}";
            };
          "org/gnome/shell/extensions/nightthemeswitcher/time" = {
            manual-schedule = false;
            nightthemeswitcher-ondemand-keybinding = [ "<Shift><Super>t" ];
            sunrise = 7;
            sunset = 17;
          };
          "org/gnome/shell/extensions/notification-timeout" = {
            always-normal = true;
            ignore-idle = true;
            timeout = 5000;
          };
          "org/gnome/shell/extensions/power-profile-switcher" = lib.mkDefault {
            # performance, balanced, power-saver
            ac = "performance";
            bat = "power-saver";
          };
          "org/gnome/shell/extensions/search-light".shortcut-search = [ "<Super>space" ];
          "org/gnome/shell/extensions/vitals" = {
            alphabetize = false;
            fixed-widths = false;
            hide-icons = false;
            hide-zeros = false;
            menu-centered = true;
            position-in-panel = 2;
            update-time = 2; # 5 seconds default
            use-higher-precision = false;
          };
          "org/gnome/shell/extensions/weatherornot".position = "clock-left";
        };

        gtk = {
          enable = true;
          cursorTheme = {
            name = stylix.cursor.name;
            package = stylix.cursor.package;
            size = stylix.cursor.size;
          };
          iconTheme = {
            name = stylix.icons.dark;
            package = stylix.icons.package;
          };
        };

        home.file = {
          ".face".source = profileImg; # Sets profile image
          "Templates/Empty file".text = ""; # Generate an empty file from right-click menu
        };

        home.packages = gnomeExts;

        xdg = {
          configFile = {
            # Nautilus bookmarks
            "gtk-3.0/bookmarks".text = ''
              file:/// /
              file:///etc/nixos nixos
              file:///mnt/nas nas
            '';
          };

          mimeApps =
            let
              mime = {
                archive = [ "org.gnome.FileRoller.desktop" ];
                audio = [
                  "org.gnome.Decibels.desktop"
                  "io.bassi.Amberol.desktop"
                  "org.gnome.Music.desktop"
                ];
                browser = [ "${browser}.desktop" ];
                calendar = [
                  "org.gnome.Calendar.desktop"
                  #"thunderbird.desktop"
                ];
                connect = [ "org.gnome.Shell.Extensions.GSConnect.desktop" ];
                email = [ "thunderbird.desktop" ];
                files = [ "org.gnome.Nautilus.desktop" ];
                image = [ "org.gnome.Loupe.desktop" ];
                pdf = [ "org.gnome.Papers.desktop" ];
                text = [ "org.gnome.TextEditor.desktop" ];
                video = [ "io.github.celluloid_player.Celluloid.desktop" ];
              };
            in
            {
              enable = true;
              defaultApplications = import ./mimeapps.nix { inherit mime; };
            };
        };
      };
  };
}
