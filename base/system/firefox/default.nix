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

  environment = {
    etc =
      let
        nmhName =
          if (gnome) then
            "gnome"
          else if (kde) then
            "kde.plasma"
          else
            "";
      in
      lib.mkIf (gnome || kde) {
        "chromium/native-messaging-hosts/org.${nmhName}.browser_connector.json".source =
          "${nmhPkg}/etc/chromium/native-messaging-hosts/org.${nmhName}.browser_connector.json";
        "opt/chrome/native-messaging-hosts/org.${nmhName}.browser_connector.json".source =
          "${nmhPkg}/etc/opt/chrome/native-messaging-hosts/org.${nmhName}.browser_connector.json";
      };
    systemPackages = lib.optionals (gnome || kde) [ nmhPkg ];
  };

  home-manager.users.${flk.user} =
    { config, osConfig, ... }:
    {
      programs = {
        ${ff.variant} = {
          enable = true;
          nativeMessagingHosts =
            lib.optionals (config.programs.firefoxpwa.enable) [
              config.programs.firefoxpwa.package
            ]
            ++ lib.optionals (gnome || kde) [ nmhPkg ];
          policies = import ./policies.nix;

          profiles.${flk.user} = {
            id = 0;
            isDefault = true;
            name = osConfig.users.users.${flk.user}.description;

            containers = import ./containers.nix;
            containersForce = true;
            search = import ./search.nix { inherit lib pkgs; };
            settings = import ./settings.nix {
              inherit
                lib
                osConfig
                ff
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

        firefoxpwa = {
          enable = true;
          settings.config = {
            runtime_enable_wayland = true;
            runtime_use_portals = true;
          };
          profiles = {
            "01KEQNSHKXFQS9Q7C7ZR7PHR68" = {
              name = "Pocket Casts";
              sites."01KEQNSHRSXZS4SB2B3N9PAVWE" = {
                name = "Pocket Casts";
                url = "https://pocketcasts.com/podcasts";
                manifestUrl =
                  "file://"
                  + (pkgs.writeText "pocketcasts.webmanifest" ''
                    {
                      "start_url":"https://pocketcasts.com/podcasts",
                      "name":"Podcasts - Pocket Casts",
                      "description":"Listen to your favorite podcasts online, in your browser. Discover the world's most powerful podcast player.",
                      "icons":[
                        {
                          "src":"https://static.pocketcasts.com/webplayer/favicons/favicon-512x512.png",
                          "type":"image/png",
                          "purpose":"any",
                          "sizes":"512x512"
                        }
                      ]
                    }
                  '');
                desktopEntry = {
                  categories = [ "Audio" ];
                  icon = pkgs.fetchurl {
                    url = "https://static.pocketcasts.com/webplayer/favicons/favicon-512x512.png";
                    sha256 = "sha256-N2Tw4m28zEJlL+EzWmiqTS89ArUEtHDnl8+trt3eR1c=";
                  };
                };
              };
            };
          };
        };
      };
    };

  services.dbus.packages = lib.optionals (gnome || kde) [ nmhPkg ];
}
