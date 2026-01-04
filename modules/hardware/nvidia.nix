{
  config,
  lib,
  pkgs,
  ffVariant,
  ffVersion,
  flk,
  myUser,
  ...
}:
let
  cfg = config.flake.hw.nvidia;
  nvidiaPkg = "latest"; # stable, latest, or beta
in
{
  options.flake.hw.nvidia.enable = lib.mkEnableOption "Nvidia GPU";

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable) {
      boot.kernelParams = [
        "nvidia.NVreg_EnableResizableBar=1"
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      ];

      environment = {
        etc."libva.conf".text = "LIBVA_MESSAGING_LEVEL=1"; # Suppress Firefox's libva logging
        systemPackages = [
          pkgs.egl-wayland
          pkgs.nvtopPackages.nvidia
        ];
        variables = {
          # Wayland
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";

          # Hardware Acceleration
          NVD_BACKEND = "direct"; # Library backend - 'direct' or 'egl'
          MOZ_DISABLE_RDD_SANDBOX = 1; # Disables Firefox's sandbox for the RDD process that the decoder runs in
          LIBVA_DRIVER_NAME = "nvidia"; # VA-API - 'nvidia' or 'vdpau'
          #CUDA_DISABLE_PERF_BOOST = 1;  # Disable high power draw when using HW acceleration - 580.105.08+ required
        };
      };

      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true; # "nvidia-drm.modeset=1" / "nvidia-drm.fbdev=1" - enables dedicated framebuffer
          nvidiaSettings = true;
          open = false; # Used by default with v560+
          package = config.boot.kernelPackages.nvidiaPackages.${nvidiaPkg}.overrideAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.bash ]; # Patches nvidia-sleep.sh via patchShebangs
          });
          powerManagement = {
            enable = true; # "nvidia.NVreg_PreserveVideoMemoryAllocations=1" - enables nvidia-hibernate/resume/suspend.services
            finegrained = false; # Experimental: Turns off GPU when not in use - cannot be used w/ nvidia.prime.sync
          };
          videoAcceleration = true; # nvidia-vaapi-driver
        };
      };

      # Firefox about:config setting(s)
      home-manager.users.${myUser}.programs.${ffVariant}.profiles.${myUser}.settings = {
        "media.rdd-ffmpeg.enabled" = lib.mkIf (lib.versionOlder ffVersion "97.0.0") true; # FF97+ defaults to true
      };

      programs.gamescope.args = [ "-F nis" ];
      services.xserver.videoDrivers = [ "nvidia" ];
    })

    #(lib.mkIf (cfg.enable && flk.de.hyprland.enable) { })

    (lib.mkIf (cfg.enable && flk.de.kde.enable) {
      # Disable GSP - Smoother Plasma Wayland experience
      boot.kernelParams = [
        "nvidia.NVreg_EnableGpuFirmware=0"
      ];
      hardware.nvidia.gsp.enable = false;
    })
  ];
}
