{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.flake.hw.amdgpu;
in
{
  options.flake.hw.amdgpu.enable = lib.mkEnableOption "AMDGPU";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages =
      builtins.attrValues {
        inherit (pkgs.nvtopPackages) amd; # GPU stats
        inherit (pkgs)
          amdgpu_top # GPU stats

          # Video acceleration libraries
          libva1-minimal
          libvdpau
          ;
      }
      ++ lib.optionals (config.hardware.amdgpu.opencl.enable) [
        pkgs.clinfo # OpenCL info | 'clinfo -l' or -a
      ];

    hardware = {
      amdgpu = {
        initrd.enable = true; # boot.initrd.kernelModules: "amdgpu"
        opencl.enable = lib.mkDefault false; # hardware.graphics.extraPackages: pkgs.rocmPackages.clr/.icd
      };

      graphics = {
        enable = true; # Mesa drivers
        # Hardware acceleration
        extraPackages = builtins.attrValues {
          inherit (pkgs)
            libva-vdpau-driver
            libvdpau-va-gl
            ;
        };
        extraPackages32 = builtins.attrValues {
          inherit (pkgs.driversi686Linux)
            libva-vdpau-driver
            libvdpau-va-gl
            ;
        };
      };
    };

    programs.gamescope.args = [ "--filter fsr" ];

    services = {
      lact = {
        enable = true; # AMDGPU controller
        #settings = { };
      };

      xserver.videoDrivers = lib.mkDefault [
        "amdgpu"
        "modesetting"
      ];
    };
  };
}
