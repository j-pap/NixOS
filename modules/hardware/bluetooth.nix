{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.flake.hw.bluetooth;
in
{
  options.flake.hw.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf (cfg.enable) {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          ControllerMode = "dual"; # bredr, le, or dual
          Experimental = true; # Battery level info / LE BAP
          KernelExperimental = true; # LE BAP ISO Socket
        };
      };
    };

    # Prevent headset from switching profiles
    services.pipewire.wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
        bluetooth.autoswitch-to-headset-profile = false
      '')
    ];

    # Fixes journalctl directory mode error
    systemd.services.bluetooth.serviceConfig.ConfigurationDirectoryMode = lib.mkForce 0755;
  };
}
