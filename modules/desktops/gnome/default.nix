{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.de.gnome;
  stylix = config.stylix;
  logoImg = ../../../base/logo.png;
  profileImg = ../../../base/profile.png;
  favApps = [
    "${flk.terminal}.desktop"
    "org.gnome.Nautilus.desktop"
    "${flk.browser}.desktop"
    "thunderbird.desktop"
  ]
  ++ lib.optionals (flk.gaming.enable) [
    "steam.desktop"
  ];
in
{
  options.flake.de.gnome.enable = lib.mkEnableOption "GNOME Desktop Environment";

  # GNOME v49.X
  config = lib.mkIf (cfg.enable) {
    flake.terminal = lib.mkDefault "kgx";

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
      ]
      ++ lib.optionals (flk.terminal != "kgx") [
        pkgs.nautilus-python            # Allow nautilus scripts
        pkgs.nautilus-open-any-terminal # Custom terminals in nautilus
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # GNOME
          dconf-editor            # GUI dconf editor
          file-roller             # Archive manager
          gnome-extension-manager # Extensions
          gnome-themes-extra      # Adwaita-dark
          gnome-tweaks            # Tweaks

          # GNOME Circle
          amberol     # Music player
          eyedropper  # Color picker

          # Multimedia
          celluloid # GTK MPV frontend w/ Wayland
          ;
      };
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
                #gst-plugins-base # Included w/ super.buildInputs
                gst-plugins-good
                #gst-plugins-bad
                #gst-plugins-ugly
                gst-vaapi
                ;
            };
        });

        # GDM dconf database doesn't change the background, so overriding the package
        gnome-shell = prev.gnome-shell.overrideAttrs (super: {
          patches = (super.patches or [ ]) ++ [
            (pkgs.writeText "bg.patch" ''
              --- a/data/theme/gnome-shell-sass/widgets/_login-lock.scss
              +++ b/data/theme/gnome-shell-sass/widgets/_login-lock.scss
              @@ -232,6 +232,10 @@ $_gdm_dialog_width: 25em;

               #lockDialogGroup {
                 background-color: $_gdm_bg;
              +  background-image: url('file://${flk.host.wallpaper.login}');
              +  background-position: center;
              +  background-repeat: no-repeat;
              +  background-size: cover;
               }

               // Clock
            '')
          ];
        });
      })
    ];

    programs = {
      dconf.profiles.gdm.databases = lib.singleton {
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
      };

      kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
    };

    security.pam.services.gdm.enableGnomeKeyring = true; # Unlock upon login

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

    system.activationScripts = {
      # Workaround to display profile image on GDM
      gdmProfileImage.text = ''
        mkdir -p /var/lib/AccountsService/{icons,users}
        cp /home/${flk.user}/.face /var/lib/AccountsService/icons/${flk.user}
        echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${flk.user}\nSession=gnome\nSystemAccount=false\n" > /var/lib/AccountsService/users/${flk.user}
      '';
      # Set GNOME fractional scaling
      monitorScale.text =
        let
          file = "/home/${flk.user}/.config/monitors.xml";
        in
        ''
          [ -f ${file} ] && ${lib.getExe' pkgs.toybox "sed"} -i '7s|>.*</|>${flk.host.monitor.scale}</|' ${file}
        '';
    };

    home-manager.users.${flk.user} = {
      imports = [
        ./displays
        ./power
        ./multitasking
        (import ./appearance { inherit config flk; })
        ./input
        (import ./keyboard { inherit flk; })
        (import ./privacy { inherit lib; })
        ./system
        ./tweaks
        (import ./extensions {
          inherit
            lib
            pkgs
            flk
            stylix
            ;
        })
      ];

      dconf.settings = {
        "ca/desrt/dconf-editor".show-warning = false;

        "org/gnome/Console" = {
          #custom-font = "Iosvmata 15";
          #custom-font = "${stylix.fonts.monospace.name} ${stylix.fonts.sizes.terminal}";
          ignore-scrollback-limit = true;
          #use-system-font = false;
        };

        "org/gnome/shell".favorite-apps = favApps;

        "org/gnome/shell/weather".automatic-location = true;

        "org/gnome/TextEditor" = {
          restore-session = false;
          show-line-numbers = true;
          tab-width = 2;
        };

        # Nautilus
        "com/github/stunkymonkey/nautilus-open-any-terminal" = lib.optionalAttrs (flk.terminal != "kgx") {
          terminal = flk.terminal;
        };
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

      xdg = {
        configFile = {
          # Nautilus bookmarks
          "gtk-3.0/bookmarks".text = ''
            file:/// /
            file:///etc/nixos nixos
            file:///mnt/nas nas
          '';
          # Force from GTK module above so HM rebuilds
          "gtk-3.0/settings.ini".force = true;
          "gtk-4.0/settings.ini".force = true;
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
              browser = [ "${flk.browser}.desktop" ];
              calendar = [
                "org.gnome.Calendar.desktop"
                #"thunderbird.desktop"
              ];
              connect = [ "org.gnome.Shell.Extensions.GSConnect.desktop" ];
              email = [ "thunderbird.desktop" ];
              files = [ "org.gnome.Nautilus.desktop" ];
              image = [ "org.gnome.Loupe.desktop" ];
              pdf = [ "org.gnome.Papers.desktop" ];
              text = [
                #"nvim.desktop"
                "org.gnome.TextEditor.desktop"
              ];
              video = [ "io.github.celluloid_player.Celluloid.desktop" ];
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
