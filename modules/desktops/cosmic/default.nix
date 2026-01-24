{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.de.cosmic;
  stylix = config.stylix;
  wallpaper = flk.host.wallpaper;
  profileImg = ../../../base/profile.png;
  favApps =
    (if (flk.terminal == "cosmic-term") then [ "com.system76.CosmicTerm" ] else [ "${flk.terminal}" ])
    ++ [
      "com.system76.CosmicFiles"
      "${flk.browser}"
      "thunderbird"
      "discord"
      "steam"
    ];
in
{
  options.flake.de.cosmic.enable = lib.mkEnableOption "COSMIC Desktop Environment";

  config = lib.mkIf (cfg.enable) {
    flake.terminal = lib.mkDefault "cosmic-term";

    environment = {
      cosmic.excludePackages = [ ];
      systemPackages = [
        #stylix.cursor.package
        #stylix.icons.package
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # Extensions
          cosmic-ext-applet-caffeine
          cosmic-ext-applet-minimon
          cosmic-ext-applet-privacy-indicator
          cosmic-ext-applet-sysinfo
          cosmic-ext-applet-weather
          cosmic-ext-calculator
          cosmic-ext-ctl
          cosmic-ext-tweaks
          ;
      };
      #sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1; # Global window clipboard access
    };

    nixpkgs.overlays = [
      (final: prev: {
        gnome-keyring = prev.gnome-keyring.overrideAttrs (super: {
          postInstall = (super.postInstall or "") + ''
            portal="$out/share/xdg-desktop-portal/portals/gnome-keyring.portal"
            substituteInPlace "$portal" \
              --replace "UseIn=gnome" "UseIn=COSMIC;gnome"
          '';
        });
      })
    ];

    programs.seahorse.enable = true;
    security.pam.services.cosmic-greeter.enableGnomeKeyring = true;

    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic = {
        enable = true;
        showExcludedPkgsWarning = true;
        xwayland.enable = true;
      };
      system76-scheduler.enable = true;
    };

    stylix.fonts = {
      monospace = {
        name = "Noto Sans Mono";
        package = pkgs.noto-fonts;
      };
      sansSerif = {
        name = "Open Sans";
        package = pkgs.open-sans;
      };
      /*
        sizes = {
          #applications = 10;
          #desktop = 10;
          #popups = 10;
          #terminal = 14;
        };
      */
    };

    systemd.packages = lib.optional (config.services.flatpak.enable) [
      pkgs.cosmic-store # Flatpak store
    ];

    home-manager.users.${flk.user} =
      { cosmicLib, ... }:
      let
        inherit (cosmicLib.cosmic) mkRON;
      in
      {
        imports = [
          ./appearance
          (import ./panels { inherit cosmicLib favApps; })
          (import ./inputs { inherit lib pkgs cosmicLib flk; })
        ];

        programs.cosmic-applibrary = {
          #enable = true;
          settings.groups = [ ];
        };

        wayland.desktopManager.cosmic = {
          enable = true;
          #resetFiles = true; # If true, resets all COSMIC settings not defined in this module
          resetFilesDirectories = [
            #"cache"
            "config"
            #"data"
            "state"
          ];
          resetFilesExclude = [
            "cosmic-initial-setup-done"
          ];

          configFile = {
            "com.system76.CosmicEdit" = {
              version = 1;
              entries = {
                tab_width = 2;
                vim_bindings = true;
              };
            };
            "com.system76.CosmicFiles" = {
              version = 1;
              entries = {
                desktop = {
                  show_content = false;
                  show_mounted_drives = false;
                  show_trash = false;
                };
                favorites = [
                  (mkRON "enum" "Home")
                  (mkRON "enum" "Documents")
                  (mkRON "enum" "Downloads")
                  (mkRON "enum" "Music")
                  (mkRON "enum" "Pictures")
                  (mkRON "enum" "Videos")
                  (mkRON "enum" {
                    variant = "Path";
                    value = [ "/" ];
                  })
                  (mkRON "enum" {
                    variant = "Path";
                    value = [ "/etc/nixos" ];
                  })
                ];
              };
            };
          };

          # COSMIC Settings -> Accessibility
          # Magnifier
          /*
            compositor.accessibility_zoom = {
              # Zoom increment
              #increment = 50;
              # Start magnifier on sign in
              #start_on_login = false;
              # Zoomed view moves
              #view_moves = mkRON "enum" "Continuously"; # Continuously, OnEdge, Centered
            };
          */

          # COSMIC Settings -> Desktop -> Wallpapers
          /*
            wallpapers = lib.singleton {
              # Same wallpaper on all displays
              output = "all";
              # Wallpaper fit
              scaling_mode = mkRON "enum" "Zoom"; # Zoom (Fill), Stretch
              #scaling_mode = mkRON "enum" { variant = "Fit"; value = [ (mkRON "tuple" [ 0.0 0.0 0.0 ]) ]; };
              # Slideshow
              rotation_frequency = 300;
              # Path / Color
              #source = mkRON "enum" { variant = "Path"; value = [ "${flk.host.wallpaper.dark}" ]; };
              filter_by_theme = true;
              filter_method = mkRON "enum" "Lanczos";
              sampling_method = mkRON "enum" "Alphanumeric";
            };
          */

          # COSMIC Settings -> Desktop -> Window management
          appearance.toolkit = {
            show_maximize = true;
            show_minimize = true;
          };
          compositor = {
            autotile_behavior = mkRON "enum" "Global"; # Global, PerWorkspace
            autotile = true;
            edge_snap_threshold = 10; # off: 0 - on: 10 (default)

            # Window controls
            active_hint = true;

            # Focus navigation
            focus_follows_cursor = true;
            #focus_follows_cursor_delay = 250;
            cursor_follows_focus = true;

            # COSMIC Settings -> Desktop -> Workspaces
            workspaces = {
              workspace_mode = mkRON "enum" "OutputBound"; # Global, OutputBound
              workspace_layout = mkRON "enum" "Horizontal"; # Vertical, Horizontal
            };
          };

          # COSMIC Settings -> Power & battery
          idle = {
            screen_off_time = mkRON "optional" 300000; # 900000
            suspend_on_ac_time = mkRON "optional" 1800000; # 1800000
            suspend_on_battery_time = mkRON "optional" 900000;
          };

          # COSMIC Settings -> Applications -> Default Applications
          systemActions = mkRON "map" [
            {
              key = mkRON "enum" "Terminal";
              value = "${flk.terminal}";
            }
          ];

          # COSMIC Settings -> Applications -> X11 applications compatibility
          #Optimize gaming/apps: mkRON "enum" "fractional" - Optimize apps: true - Compatibility: false
          #compositor.descale_xwayland = false;
        };

        home.file.".face".source = profileImg; # Sets profile image

        # Set default application file associations
        xdg.mimeApps =
          let
            mime = {
              archive = [ "org.gnome.FileRoller.desktop" ];
              audio = [ "com.system76.CosmicPlayer.desktop" ];
              browser = [ "${flk.browser}.desktop" ];
              calendar = [ "thunderbird.desktop" ];
              connect = [ "" ];
              email = [ "thunderbird.desktop" ];
              files = [ "com.system76.CosmicFiles.desktop" ];
              image = [ "org.gnome.eog.desktop" ];
              pdf = [ "org.gnome.Evince.desktop" ];
              text = [ "com.system76.CosmicEdit.desktop" ];
              video = [ "com.system76.CosmicPlayer.desktop" ];
            };
          in
          {
            enable = false;
            associations.added = config.xdg.mimeApps.defaultApplications;
            defaultApplications = import ./mimeapps.nix { inherit mime; };
          };
      };
  };
}
