{
  cosmicLib,
  favApps,
  ...
}:
let
  inherit (cosmicLib.cosmic) mkRON;
in
{
  wayland.desktopManager.cosmic = {
    # COSMIC Settings -> Desktop -> Panel
    panels = [
      (import ./panel.nix { inherit cosmicLib; })
      (import ./dock.nix { inherit cosmicLib; })
    ];

    # Panel -> Applet(s)
    configFile."io.github.cosmic_utils.weather-applet" = {
      version = 1;
      entries = {
        use_fahrenheit = true;
        use_ip_location = true;
      };
    };
    applets = {
      panel-button.settings = {
        configs = mkRON "map" [
          {
            key = "Panel";
            value = {
              force_presentation = mkRON "optional" (mkRON "enum" "Icon");
            };
          }
          {
            key = "Dock";
            value = {
              force_presentation = mkRON "optional" (mkRON "enum" "Icon");
            };
          }
        ];
      };

      # COSMIC Settings -> Time & language
      time.settings = {
        military_time = true;
        show_seconds = false;
        first_day_of_week = 6;
        show_date_in_top_panel = true;
        #show_weekday = true;
      };
      #audio.settings.show_media_controls_in_top_panel = true;
      app-list.settings = {
        enable_drag_source = true;
        favorites = favApps;
        #filter_top_lists = mkRON "optional" (mkRON "enum" "ActiveWorkspace");
      };
    };
  };
}
