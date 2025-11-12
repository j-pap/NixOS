{
  config,
  lib,
  pkgs,
  cfgOpts,
  ffVersion,
  myUser,
  ...
}:
{
  options.myOptions.browser = lib.mkOption {
    default = "firefox";
    description = "Which Firefox-based browser to configure via Home-Manager: firefox, floorp, or librewolf";
    type = lib.types.str;
  };

  config = {
    _module.args.ffVersion = config.home-manager.users.${myUser}.programs.${cfgOpts.browser}.package.version;

    home-manager.users.${myUser} = {
      programs.${cfgOpts.browser} = {
        enable = true;
        nativeMessagingHosts = (lib.optionals (cfgOpts.desktops.gnome.enable) [
          pkgs.gnome-browser-connector
        ]) ++ (lib.optionals (cfgOpts.desktops.kde.enable) [
          pkgs.kdePackages.plasma-browser-integration
        ]);
        policies = import ./policies.nix;

        profiles.${myUser} = {
          id = 0;
          name = config.users.users.${myUser}.description;
          isDefault = true;

          containers = import ./containers.nix;
          containersForce = true;
          search = import ./search.nix { inherit lib pkgs; };
          settings = import ./settings.nix { inherit config lib cfgOpts ffVersion; };

          extensions.packages = let
            inherit (pkgs.nur.repos.rycee) firefox-addons;
            bypass-paywalls = import ./addons/bypass-paywalls-clean.nix {
              inherit lib;
              inherit (firefox-addons) buildFirefoxXpiAddon;
            };
          in [
            bypass-paywalls
          ] ++ builtins.attrValues {
            # Search extensions at: https://nur.nix-community.org/repos/rycee/
            inherit (firefox-addons)
              # Additional 'rycee.firefox-addons' extensions
              enhancer-for-youtube
            ;
          };
        };
      };
    };
  };
}
