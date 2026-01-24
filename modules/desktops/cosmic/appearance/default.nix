{
  cosmicLib,
  ...
}:
let
  inherit (cosmicLib.cosmic) mkRON;

  hintSize = 1; # 3
  gapSize = mkRON "tuple" [
    0
    5
  ]; # [ 0 8 ]
  density = mkRON "enum" "Compact"; # null or Compact, Standard, Spacious
in
{
  wayland.desktopManager.cosmic = {
    # COSMIC Settings -> Desktop -> Appearance
    configFile."com.system76.CosmicTheme.Mode" = {
      version = 1;
      entries.auto_switch = true;
    };

    appearance = {
      theme = {
        #mode = null; # null, dark, light
        dark = import ./dark.nix { inherit cosmicLib hintSize gapSize; };
        light = import ./light.nix { inherit cosmicLib hintSize gapSize; };
      };
      toolkit = {
        # Interface density
        interface_density = density;
        header_size = density;

        # Experimental settings
        # System font
        interface_font = {
          family = "Open Sans";
          stretch = mkRON "enum" "Normal";
          style = mkRON "enum" "Normal";
          weight = mkRON "enum" "Normal";
        };
        # Monospace font
        monospace_font = {
          family = "Noto Sans Mono";
          stretch = mkRON "enum" "Normal";
          style = mkRON "enum" "Normal";
          weight = mkRON "enum" "Normal";
        };
        # Icons and toolkit themeing
        # Apply to GNOME apps
        apply_theme_global = true;
        # Icon theme
        icon_theme = "Cosmic"; # Adwaita, Cosmic, Pop
      };
    };
  };
}
