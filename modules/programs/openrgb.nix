{
  config,
  lib,
  pkgs,
  myUser,
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
      package = pkgs.openrgb.overrideAttrs (_: {
        version = "1.0rc1-pipeline";
        src = pkgs.fetchFromGitLab {
          owner = "CalcProgrammer1";
          repo = "OpenRGB";
          rev = "a2315a45ff9372834ff1c9773d6529088c219d87";
          sha256 = "sha256-HuHhKp4eNdK2SLh1PyJX2nH9f1OO04fo20PNe96SvoI=";
        };
        postPatch = ''
          patchShebangs scripts/build-udev-rules.sh
          substituteInPlace scripts/build-udev-rules.sh \
            --replace "/usr/bin/env chmod" "${lib.getExe' pkgs.coreutils "chmod"}"
        '';
      });
    };

    systemd.user.services.openrgb = {
      enable = true;
      description = "Launch OpenRGB after logon";
      serviceConfig = {
        ExecStart = "${lib.getExe config.services.hardware.openrgb.package} --startminimized";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      wantedBy = [ "graphical-session.target" ];
    };

    users.users.${myUser}.extraGroups = [ "i2c" ];
  };
}
