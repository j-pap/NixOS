{
  config,
  lib,
  pkgs,
  inputs,
  browser,
  flk,
  ...
}:
let
  cfg = config.flake.de.hyprland;
  stylix = config.stylix;
  editor = config.environment.variables.EDITOR;
in
{
  imports = [
    ./greetd.nix
  ];

  options.flake.de.hyprland.enable = lib.mkEnableOption "Hyprland WM";

  config = lib.mkIf (cfg.enable) {
    flake.terminal = lib.mkDefault "kitty";

    environment = {
      pathsToLink = [ "/share/icons" ];

      sessionVariables.NIXOS_OZONE_WL = 1;

      systemPackages =
        builtins.attrValues {
          inherit (pkgs)
            # Application Launcher
            #bc                  # Calculator for rofi-wifi script
            #hyprlauncher        # App launcher (via HM)
            #iw                  # wireless config for rofi-wifi script
            #rofi-wayland        #
            #wofi                # Launcher

            # Audio
            hyprpwcenter         # Pipewire display

            # Authorization Agent
            #hyprpolkitagent     # Hypr's polkit agent (via HM)
            #polkit_gnome        # Gnome's polkit agent (via HM)

            # Clipboard
            cliphist             # Save clipboard history after closing apps

            # File Manager
            file-roller          # Gnome's GUI archive manager
            pcmanfm              # Independent file manager

            # Hardware
            brightnessctl        # Monitor brightness control

            # Hypr Ecosystem
            hyprpicker           # Utility for picking a color from your screen
            hyprshutdown         # GUI session manager (via Flake)
            hyprsysteminfo       # Display system information

            # Status bar
            networkmanagerapplet # Show network tray icon (nm-applet --indicator)
            #ashell
            #dms-shell

            # Theming
            #pywal               # Theme colors from current wallpaper
            #wpgtk               # Pywal GUI

            # Wallpaper
            #swww                # Wallpaper manager capable of GIFs (via HM)
            #awww                # New repo for swww

            # Wayland
            wayland-utils        # Wayland utilities | 'wayland-info'
            wev                  # Keymapper
            ;
        }
        ++ [
          # QT Wayland
          pkgs.libsForQt5.qt5.qtwayland # QT5 Wayland
          pkgs.kdePackages.qtwayland    # QT6 Wayland
        ]
        ++ lib.optional (config.services.flatpak.enable) [
          pkgs.gnome-software # Flatpak store
        ];
    };

    fonts.packages = builtins.attrValues {
      inherit (pkgs)
        font-awesome # Icons
        ;

      inherit (pkgs.nerd-fonts)
        noto # Waybar icons
        ;
    };

    home-manager.users.${flk.user} =
      {
        config,
        lib,
        osConfig,
        ...
      }:
      let
        theme = {
          #name = "";
          #pkg = pkgs.;
        };
      in
      {
        imports = [
          ./hypr
          ./waybar
          ./idle.nix
          ./lock.nix
          ./launcher.nix
          #./paper.nix
          ./sunset.nix
        ];

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
          #theme = {
          #name = theme.name;
          #package = theme.pkg;
          #};
        };

        home =
          let
            profileImg = ../../../assets/profile.png;
          in
          {
            file.".face".source = profileImg;
            pointerCursor = {
              enable = true;
              gtk.enable = true;
              hyprcursor.enable = true;
              name = stylix.cursor.name;
              package = stylix.cursor.package;
              size = stylix.cursor.size;
            };
          };

        programs = {
          hyprshot = {
            enable = true;
            package = pkgs.hyprshot;
            saveLocation = "$HOME/Pictures/hyprshot";
          };

          /*
            # Use Pywal for terminal theming
            bash.initExtra = ''
              if command -v wal > /dev/null 2>&1 && [ "$TERM" = "${flk.terminal}" ]; then
                wal -Rqe
              fi
            '';
            kitty.extraConfig = ''include /home/${flk.user}/.cache/wal/colors-kitty.conf'';
          */
        };

        /*
          qt = {
            enable = true;
            style = {
              name = theme.name;
              package = theme.pkg;
          };
        */

        services = {
          hyprpolkitagent.enable = true;
          playerctld.enable = true;
          #polkit-gnome.enable = true;
          swww = {
            enable = true;
            extraArgs = [ ];
          };
          udiskie = {
            enable = true;
            automount = true;
            notify = true;
            tray = "auto";
            settings = { };
          };
        };

        # v0.52.2 - https://wiki.hypr.land/Configuring/
        wayland.windowManager.hyprland = {
          enable = true;
          package = null; # Use NixOS module package
          portalPackage = null; # Use NixOS module package
          systemd = {
            enable = true;
            enableXdgAutostart = false;
            variables = [ "--all" ];
          };
          xwayland.enable = true;

          settings = {
            # https://wiki.hypr.land/Configuring/Keywords/#sourcing-multi-file
            source = [
              # Import optional color schemes
              #"/home/${flk.user}/.cache/wal/colors-hyprland.conf"
            ];

            "$browser" = browser;
            "$editor" = editor;
            "$files" = "pcmanfm";
            "$runner" = "hyprlauncher";
            "$screenshot" = "hyprshot";
            "$terminal" = flk.terminal;
          };
        };

        xdg = {
          # Create hyprland pywal template
          /*
            configFile."wal/templates/colors-hyprland.conf".text = ''
              $background = rgb({background.strip})
              $foreground = rgb({foreground.strip})
              $color0 = rgb({color0.strip})
              $color1 = rgb({color1.strip})
              $color2 = rgb({color2.strip})
              $color3 = rgb({color3.strip})
              $color4 = rgb({color4.strip})
              $color5 = rgb({color5.strip})
              $color6 = rgb({color6.strip})
              $color7 = rgb({color7.strip})
              $color8 = rgb({color8.strip})
              $color9 = rgb({color9.strip})
              $color10 = rgb({color10.strip})
              $color11 = rgb({color11.strip})
              $color12 = rgb({color12.strip})
              $color13 = rgb({color13.strip})
              $color14 = rgb({color14.strip})
              $color15 = rgb({color15.strip})
            '';
          */

          # Set default application file associations
          mimeApps =
            let
              mime = {
                archive = [
                  "org.gnome.FileRoller.desktop"
                  #"org.kde.ark.desktop"
                ];
                audio = [ "" ];
                browser = [ "${browser}.desktop" ];
                calendar = [ "" ];
                connect = [ "" ];
                email = [ "thunderbird.desktop" ];
                image = [ "feh.desktop" ];
                pdf = [
                  #"${browser}.desktop"
                  "org.pwmt.zathura.desktop"
                ];
                text = [ "neovide.desktop" ];
                video = [ "" ];
              };
            in
            {
              enable = true;
              associations.added = config.xdg.mimeApps.defaultApplications;
              defaultApplications = import ../mimeapps.nix { inherit mime; };
            };
        };
      };

    nixpkgs.overlays = [
      inputs.hyprshutdown.overlays.default
    ];

    programs = {
      hyprland =
        let
          hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          enable = true;
          package = hyprPkgs.hyprland;
          portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
          xwayland.enable = true;
        };
      seahorse.enable = true;
    };

    security = {
      pam.services = {
        hyprlock = { }; # Enable keyboard input after locking
        greetd.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
      polkit.enable = true;
    };

    services = {
      dbus.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    stylix = {
      fonts = {
        sizes = {
          #applications = 10;
          #desktop = 10;
          #popups = 10;
          #terminal = 14;
        };
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        #pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        #"org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
      };
    };
  };
}
