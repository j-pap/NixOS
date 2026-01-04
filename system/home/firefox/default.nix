{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  flk = osConfig.flake;
  ffVariant = osConfig._module.args.ffVariant;
  ffVersion = osConfig._module.args.ffVersion;
in
{
  programs.${ffVariant} = {
    enable = true;
    nativeMessagingHosts =
      (lib.optionals (flk.de.gnome.enable) [
        pkgs.gnome-browser-connector
      ])
      ++ (lib.optionals (flk.de.kde.enable) [
        pkgs.kdePackages.plasma-browser-integration
      ]);
    policies = import ./policies.nix;

    profiles.${config.home.username} = {
      id = 0;
      name = osConfig.users.users.${config.home.username}.description;
      isDefault = true;

      containers = import ./containers.nix;
      containersForce = true;
      search = import ./search.nix { inherit lib pkgs; };
      settings = import ./settings.nix {
        inherit
          lib
          osConfig
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
}
