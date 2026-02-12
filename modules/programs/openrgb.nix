{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.openrgb;
in
{
  options.flake.openrgb.enable = lib.mkEnableOption "OpenRGB";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [ pkgs.i2c-tools ];

    hardware.i2c.enable = true;

    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb;
      #server.port = 6742;
      startupProfile = config.networking.hostName;
    };

    users.users.${flk.user}.extraGroups = [ "i2c" ];
  };
}
