{
  config,
  lib,
  pkgs,
  cfgOpts,
  myUser,
  ...
}: let
  cfg = cfgOpts.hardware.nvidia;
  nvidiaPkg = "stable"; # or beta
in {
  options.myOptions.hardware.nvidia.enable = lib.mkEnableOption "Nvidia GPU";

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable) {
      boot.kernelParams = [
        "nvidia.NVreg_EnableResizableBar=1"
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      ];

      environment = {
        etc."libva.conf".text = "LIBVA_MESSAGING_LEVEL=1";  # Suppress Firefox's libva logging
        systemPackages = [
          pkgs.egl-wayland
          pkgs.nvtopPackages.nvidia
        ];
        variables = {
          __GL_GSYNC_ALLOWED = 1;
          __GL_VRR_ALLOWED = 1;
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          GBM_BACKEND = "nvidia-drm";  # Could possibily cause Firefox to crash - comment out if so
          LIBVA_DRIVER_NAME = "nvidia";  # Hardware Acceleration - 'nvidia' or 'vdpau'
          MOZ_DISABLE_RDD_SANDBOX = 1;  # Disables Firefox's sandbox for the RDD process that the decoder runs in
          NVD_BACKEND = "direct";  # Library backend - 'direct' or 'egl'
        };
      };

      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;  # "nvidia-drm.modeset=1" / "nvidia-drm.fbdev=1" enables dedicated framebuffer
          nvidiaSettings = true;
          open = false;  # Starting w/ 560, open drivers are used by default
          package = config.boot.kernelPackages.nvidiaPackages.${nvidiaPkg}.overrideAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.bash ];  # Patches nvidia-sleep.sh via patchShebangs
          });
          powerManagement = {
            # "nvidia.NVreg_PreserveVideoMemoryAllocations=1" / enables nvidia-hibernate/resume/suspend.services
              # enable if graphical corruption on resumption from suspend
            enable = true;
            finegrained = false;  # Experimental: Turns off GPU when not in use - cannot be used w/ nvidia.prime.sync
          };
          videoAcceleration = true;  # nvidia-vaapi-driver
        };
      };

      # Firefox about:config(s)
      home-manager.users.${myUser}.programs.${cfgOpts.browser}.profiles.${myUser}.settings = {
        "gfx.x11-egl.force-enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
      };

      programs.gamescope.args = [ "-F nis" ];
      services.xserver.videoDrivers = [ "nvidia" ];
    })

    #(lib.mkIf (cfg.enable && cfgOpts.desktops.hyprland.enable) { })

    (lib.mkIf (cfg.enable && cfgOpts.desktops.kde.enable) {
      boot.kernelParams = [
        "nvidia.NVreg_EnableGpuFirmware=0"  # Disable GSP Mode - Smoother Plasma Wayland experience
      ];
    })
  ];
}
