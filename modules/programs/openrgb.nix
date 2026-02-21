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

    powerManagement.resumeCommands = "systemctl restart openrgb.service";

    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb.overrideAttrs (super: {
        version = "1.0rc2-pipeline-2026-02-13";
        src = pkgs.fetchFromGitLab {
          owner = "CalcProgrammer1";
          repo = "OpenRGB";
          rev = "880dc1450d0bcd27eec2bc9526590ffb40e87e78";
          sha256 = "sha256-TsMOujVI178r887IIh7fTPJRKxT3VIi965mipZcimzI=";
        };
        patches = [ (builtins.elemAt super.patches 0) ]; # Source's fetchpatch is already merged w/ pipeline
      });
      #server.port = 6742;
      startupProfile = config.networking.hostName;
    };

    users.users.${flk.user}.extraGroups = [ "i2c" ];
  };
}
