{
  config,
  lib,
  flk,
  ...
}:
let
  cfg = config.flake.syncthing;
in
{
  options.flake.syncthing.enable = lib.mkEnableOption "Syncthing";

  config = lib.mkIf (cfg.enable) {
    services.syncthing = {
      enable = true;
      configDir = "/home/${flk.user}/.config/syncthing";
      dataDir = "/home/${flk.user}";
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      user = flk.user;

      settings = {
        devices."NAS".id = "FN25ISC-P52A3WA-GRV4SIR-YI4KBMM-2I5BECF-32SLV5B-5DADP5B-YSMVIQ4";
        folders = {
          "music" = lib.mkIf (config.networking.hostName == "FW13") {
            enable = true;
            devices = [ "NAS" ];
            label = "Music";
            path = "/home/${flk.user}/Music";
          };

          "obsidian" = {
            enable = true;
            devices = [ "NAS" ];
            label = "Obsidian";
            path = "/home/${flk.user}/Obsidian";
            versioning = {
              type = "simple";
              params = {
                cleanoutDays = "90";
                cleanInterval = "3600";
                keep = "3";
              };
            };
          };

          "training" = {
            enable = true;
            devices = [ "NAS" ];
            label = "Training";
            path = "/home/${flk.user}/training";
            versioning = {
              type = "simple";
              params = {
                cleanoutDays = "30";
                cleanInterval = "3600";
                keep = "1";
              };
            };
          };
        };
        options.urAccepted = -1;
      };
    };

    users.users.${flk.user}.extraGroups = [ "syncthing" ];
  };
}
