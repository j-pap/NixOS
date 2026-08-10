{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.hw.scanner;
in
{
  options.flake.hw.scanner.enable = lib.mkEnableOption "scanning";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [
      pkgs.naps2 # Scanning software
    ];

    hardware.sane = {
      enable = true;
      extraBackends = [
        pkgs.epsonscan2
      ];
    };

    services.udev.packages = [
      pkgs.epsonscan2
    ];

    users.users.${flk.user}.extraGroups = [ "scanner" ];
  };
}
