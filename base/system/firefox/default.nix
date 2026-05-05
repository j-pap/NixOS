{
  config,
  lib,
  pkgs,
  ff,
  flk,
  ...
}:
let
  gnome = flk.de.gnome.enable;
  kde = flk.de.kde.enable;
  nmhPkg =
    if (gnome) then
      pkgs.gnome-browser-connector
    else if (kde) then
      pkgs.kdePackages.plasma-browser-integration
    else
      null;
in
{
  _module.args.ff = {
    variant = "firefox"; # firefox, floorp, or librewolf
    version = config.home-manager.users.${flk.user}.programs.${ff.variant}.package.version;
  };

  environment.systemPackages = lib.optionals (gnome || kde) [ nmhPkg ];

  home-manager.users.${flk.user} =
    { config, osConfig, ... }:
    {
      programs.${ff.variant} = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        nativeMessagingHosts =
          lib.optionals (gnome || kde) [ nmhPkg ]
          ++ lib.optionals (config.programs.firefoxpwa.enable) [
            config.programs.firefoxpwa.package
          ];
        policies = import ./policies.nix;
        profiles.${flk.user} = {
          id = 0;
          name = osConfig.users.users.${flk.user}.description;
          isDefault = true;
          containers = import ./containers.nix;
          containersForce = true;
          search = import ./search.nix { inherit lib pkgs; };
          settings = import ./settings.nix {
            inherit lib osConfig ff;
          };
          extensions.packages =
            let
              inherit (pkgs.nur.repos.rycee) firefox-addons;
              customExts = [ "bypass-paywalls-clean" ];
            in
            (map (
              ext:
              import ./addons/${ext}.nix {
                inherit lib;
                inherit (firefox-addons) buildFirefoxXpiAddon;
              }
            ) customExts)
            ++ builtins.attrValues {
              # Search extensions at: https://nur.nix-community.org/repos/rycee/
              inherit (firefox-addons)
                # Additional 'rycee.firefox-addons' extensions
                #enhancer-for-youtube
                ;
            };
        };
      };
    };

  services.dbus.packages = lib.optionals (gnome || kde) [ nmhPkg ];
}
