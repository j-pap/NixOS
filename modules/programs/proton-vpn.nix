{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.protonvpn;
  protonVpnPkg = pkgs.protonvpn-gui; # pkgs or pkgs.stable
in
{
  options.flake.protonvpn.enable = lib.mkEnableOption "Proton VPN";

  config = lib.mkIf (cfg.enable) {
    boot.kernelModules = [
      # https://github.com/ProtonVPN/proton-vpn-gtk-app/issues/57#issuecomment-2994148066
      "dummy" # Wireguard fix
    ];

    environment.systemPackages = [ protonVpnPkg ];

    home-manager.users.${flk.user} = lib.mkMerge [
      # Autostart via Hyprland
      (lib.mkIf (flk.de.hyprland.enable) {
        wayland.windowManager.hyprland.settings.exec-once = [ "protonvpn-app --start-minimized" ];
      })

      # Autostart via DE
      (lib.mkIf (!flk.de.hyprland.enable) {
        xdg.configFile."autostart/ProtonVPN.desktop".text = lib.concatLines [
          (lib.replaceStrings [ "Exec=protonvpn-app" ] [ "Exec=protonvpn-app --start-minimized" ] (
            lib.fileContents "${protonVpnPkg}/share/applications/proton.vpn.app.gtk.desktop"
          ))
          (lib.optionalString (flk.de.gnome.enable) "X-GNOME-Autostart-enabled=true")
        ];
      })
    ];

    networking.firewall.checkReversePath = "loose";
  };
}
