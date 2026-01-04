{
  config,
  lib,
  pkgs,
  myUser,
  ...
}:
let
  cfg = config.flake.hw.audio;
in
{
  options.flake.hw.audio.enable = lib.mkOption {
    default = true;
    description = "Whether to enable audio (PipeWire)";
    example = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [
      #pkgs.pwvucontrol # PipeWire audio control
    ];

    security.rtkit.enable = true; # Real-time audio

    services = {
      pipewire = {
        enable = true;
        jack.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
      pulseaudio.enable = false; # Must be disabled w/ PipeWire
    };

    users.users.${myUser}.extraGroups = [ "audio" ];
  };
}
