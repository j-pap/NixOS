{
  cosmicLib,
  hintSize,
  gapSize,
}:
let
  inherit (cosmicLib.cosmic) mkRON;
in
{
  /*
    palette = mkRON "enum" {
      variant = "Dark";
      value = lib.singleton {
        name = "custom-dark";
        bright_red = { };
        bright_green = { };
        bright_orange = { };
        gray_1 = { };
        gray_2 = { };
        neutral_0 = { };
        neutral_1 = { };
        neutral_2 = { };
        neutral_3 = { };
        neutral_4 = { };
        neutral_5 = { };
        neutral_6 = { };
        neutral_7 = { };
        neutral_8 = { };
        neutral_9 = { };
        neutral_10 = { };
        accent_blue = { };
        accent_indigo = { };
        accent_purple = { };
        accent_pink = { };
        accent_red = { };
        accent_orange = { };
        accent_yellow = { };
        accent_green = { };
        accent_warm_grey = { };
        ext_warm_grey = { };
        ext_orange = { };
        ext_yellow = { };
        ext_blue = { };
        ext_purple = { };
        ext_pink = { };
        ext_indigo = { };
      };
    };
    #spacing = { }; # Custom density outside defaults
    #neutral_tint = mkRON "optional" { };
    #bg_color = mkRON "optional" { };
    #primary_container_bg = null; # null or optional
    #secondary_container_bg = null; # null or optional
    #text_tint = mkRON "optional" { };
    #accent = mkRON "optional" { };
    #success = mkRON "optional" { };
    #warning = mkRON "optional" { };
    #destructive = mkRON "optional" { };
    #is_frosted = null; # Transparency not yet implemented - null, true, false
    #window_hint = null; # Use theme accent color for hint - null or optional
  */

  # Style -> Slightly round
  corner_radii = {
    radius_0 = mkRON "tuple" [
      0.0
      0.0
      0.0
      0.0
    ];
    radius_xs = mkRON "tuple" [
      2.0
      2.0
      2.0
      2.0
    ];
    radius_s = mkRON "tuple" [
      8.0
      8.0
      8.0
      8.0
    ];
    radius_m = mkRON "tuple" [
      8.0
      8.0
      8.0
      8.0
    ];
    radius_l = mkRON "tuple" [
      8.0
      8.0
      8.0
      8.0
    ];
    radius_xl = mkRON "tuple" [
      8.0
      8.0
      8.0
      8.0
    ];
  };

  # Window management -> Active window hint size
  active_hint = hintSize;
  # Window management -> Gaps around tiled windows
  gaps = gapSize;
}
