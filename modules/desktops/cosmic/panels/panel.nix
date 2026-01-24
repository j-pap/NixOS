{
  cosmicLib,
  ...
}:
let
  inherit (cosmicLib.cosmic) mkRON;
in
{
  name = "Panel";
  # Behavior and positions
  autohide = null;
  anchor = mkRON "enum" "Top";
  output = mkRON "enum" "All";
  # Style
  anchor_gap = true;
  margin = 4;
  expand_to_edges = true;
  background = mkRON "enum" "ThemeDefault"; # ThemeDefault, Dark, Light
  size = mkRON "enum" "XS"; # XS, S, M, L, XL
  opacity = 0.70;
  # Configuration
  plugins_center = mkRON "optional" [
    "io.github.cosmic_utils.weather-applet"
    "com.system76.CosmicAppletTime"
    "dev.DBrox.CosmicPrivacyIndicator"
  ];
  plugins_wings = mkRON "optional" (
    mkRON "tuple" [
      # Left
      [
        "com.system76.CosmicPanelAppButton"
        "com.system76.CosmicAppletWorkspaces"
      ]
      # Right
      [
        "io.github.cosmic_utils.minimon-applet"
        "com.system76.CosmicAppletStatusArea"
        "com.system76.CosmicAppletTiling"
        "com.system76.CosmicAppletAudio"
        "com.system76.CosmicAppletBluetooth"
        "com.system76.CosmicAppletNetwork"
        "com.system76.CosmicAppletBattery"
        "net.tropicbliss.CosmicExtAppletCaffeine"
        "com.system76.CosmicAppletNotifications"
        "com.system76.CosmicAppletPower"
      ]
    ]
  );
}
