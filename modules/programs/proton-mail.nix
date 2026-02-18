{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.protonmail;
  protonMbPkg = pkgs.protonmail-bridge-gui; # pkgs or pkgs.stable
in
{
  options.flake.protonmail.enable = lib.mkEnableOption "Proton Mail Bridge";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [ protonMbPkg ];

    home-manager.users.${flk.user} = lib.mkMerge [
      # Autostart via Hyprland
      (lib.mkIf (flk.de.hyprland.enable) {
        wayland.windowManager.hyprland.settings.exec-once = [ "protonmail-bridge-gui --no-window" ];
      })

      # Autostart via DE
      (lib.mkIf (!flk.de.hyprland.enable) {
        xdg.configFile."autostart/ProtonMailBridge.desktop".text = lib.concatLines [
          (lib.replaceStrings [ "Exec=protonmail-bridge-gui" ] [ "Exec=protonmail-bridge-gui --no-window" ] (
            lib.fileContents "${protonMbPkg}/share/applications/proton-bridge-gui.desktop"
          ))
          (lib.optionalString (flk.de.gnome.enable) "X-GNOME-Autostart-enabled=true")
        ];
      })
    ];

    services.protonmail-bridge = {
      enable = false;
      package = pkgs.protonmail-bridge; # pkgs, pkgs.stable, or protonMbPkg
      logLevel = null; # null, debug, info, warn, error, fatal, panic
      path = [ ];
    };
  };
}
