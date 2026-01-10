{
  config,
  lib,
  pkgs,
  ffVariant,
  ffVersion,
  flk,
  ...
}:
let
  gnome = flk.de.gnome.enable;
  kde = flk.de.kde.enable;

  nmName =
    if (gnome) then
      "gnome"
    else if (kde) then
      "kde.plasma"
    else
      "";
  nmPkg =
    if (gnome) then
      pkgs.gnome-browser-connector
    else if (kde) then
      pkgs.kdePackages.plasma-browser-integration
    else
      null;
in
{
  _module.args = {
    ffVariant = "firefox"; # firefox, floorp, or librewolf
    ffVersion = config.home-manager.users.${flk.user}.programs.${ffVariant}.package.version;
  };

  environment = {
    etc = lib.mkIf (gnome || kde) {
      "chromium/native-messaging-hosts/org.${nmName}.browser_connector.json".source =
        "${nmPkg}/etc/chromium/native-messaging-hosts/org.${nmName}.browser_connector.json";
      "opt/chrome/native-messaging-hosts/org.${nmName}.browser_connector.json".source =
        "${nmPkg}/etc/opt/chrome/native-messaging-hosts/org.${nmName}.browser_connector.json";
    };
    systemPackages = lib.optionals (gnome || kde) [ nmPkg ];
  };

  home-manager.users.${flk.user} = {
    programs.${ffVariant} = {
      enable = true;
      nativeMessagingHosts = lib.optionals (gnome || kde) [ nmPkg ];
      policies = import ./policies.nix;

      profiles.${flk.user} = {
        id = 0;
        name = config.users.users.${flk.user}.description;
        isDefault = true;

        containers = import ./containers.nix;
        containersForce = true;
        search = import ./search.nix { inherit lib pkgs; };
        settings = import ./settings.nix {
          inherit
            config
            lib
            ffVariant
            ffVersion
            ;
        };

        extensions.packages =
          let
            inherit (pkgs.nur.repos.rycee) firefox-addons;
            bypass-paywalls = import ./addons/bypass-paywalls-clean.nix {
              inherit lib;
              inherit (firefox-addons) buildFirefoxXpiAddon;
            };
          in
          [
            bypass-paywalls
          ]
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

  services.dbus.packages = lib.optionals (gnome || kde) [ nmPkg ];
}
