{
  pkgs,
  ...
}:
let
  # https://github.com/emersion/mako/wiki/Volume-change-notification
in {
  # https://home-manager-options.extranix.com/?query=services.mako.&release=master
  services.mako = {
    enable = true;

    settings = {
      # https://github.com/emersion/mako/wiki/Example-configuration
      anchor = "top-right";

      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };
}
