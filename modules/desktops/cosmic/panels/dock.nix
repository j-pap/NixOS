{
  cosmicLib,
  ...
}:
let
  inherit (cosmicLib.cosmic) mkRON;
in
{
  name = "Dock";
  # Behavior and positions
  autohide = mkRON "optional" {
    wait_time = 1000;
    transition_time = 200;
    handle_size = 4;
    unhide_delay = 200;
  };
  anchor = mkRON "enum" "Bottom";
  output = mkRON "enum" "All";
  # Style
  anchor_gap = true;
  margin = 4;
  expand_to_edges = false;
  background = mkRON "enum" "ThemeDefault"; # ThemeDefault, Dark, Light
  size = mkRON "enum" "M"; # XS, S, M, L, XL
  opacity = 1.0;
  # Configuration
  plugins_center = mkRON "optional" [
    "com.system76.CosmicAppList"
  ];
  plugins_wings = mkRON "optional" (
    mkRON "tuple" [
      # Left
      [
      ]
      # Right
      [
        "com.system76.CosmicAppletMinimize"
      ]
    ]
  );
}
