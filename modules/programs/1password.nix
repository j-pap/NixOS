{
  config,
  lib,
  flk,
  ...
}:
let
  cfg = config.flake."1password";
in
{
  options.flake."1password".enable = lib.mkEnableOption "1Password";

  config = lib.mkIf (cfg.enable) {
    # Allow _1password-gui to communicate w/ the browser extension
    environment.etc."1password/custom_allowed_browsers" = {
      mode = "0755";
      text = flk.browser;
    };

    home-manager.users.${flk.user} = lib.mkMerge [
      # Autostart via Hyprland
      (lib.mkIf (flk.de.hyprland.enable) {
        wayland.windowManager.hyprland.settings.exec-once = [
          "1password --silent %U"
        ];
      })

      # Autostart via DE
      (lib.mkIf (!flk.de.hyprland.enable) {
        xdg.configFile."autostart/1password.desktop" = {
          text = lib.replaceStrings [ "Exec=1password %U" ] [ "Exec=1password --silent %U" ] (
            lib.fileContents "${config.programs._1password-gui.package}/share/applications/1password.desktop"
          );
        };
      })
    ];

    programs = {
      _1password.enable = false; # CLI
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ flk.user ];
      };
    };

    users.users.${flk.user}.extraGroups = [ "onepassword" ];
  };
}
