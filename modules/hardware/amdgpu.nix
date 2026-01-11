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
  options.flake.hw.amdgpu = {
    enable = lib.mkEnableOption "AMDGPU";
    uv = {
      enable = lib.mkEnableOption "AMDGPU undervolting support";
      gpu = lib.mkOption {
        description = "GPU's persistant path can be found by running: 'readlink -f /sys/class/drm/card*/device'";
        example = "/sys/devices/pci0000:00/.../.../...";
        type = lib.types.str;
      };
      clockMin = lib.mkOption {
        description = "GPU's minimum clock speed";
        example = 500;
        type = lib.types.int;
      };
      clockMax = lib.mkOption {
        description = "GPU's maximum clock speed";
        example = 2664;
        type = lib.types.int;
      };
      powerLimit = lib.mkOption {
        description = "GPU's power limit via wattage (first 3 digits are watts)";
        example = 284000000;
        type = lib.types.int;
      };
      voltOffset = lib.mkOption {
        description = "GPU's negative voltage offset";
        example = -150;
        type = lib.types.int;
      };
      vramClock = lib.mkOption {
        description = "GPU's VRAM maximum clock speed";
        example = 1124;
        type = lib.types.int;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable) {
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
          # Mesa drivers
          enable = true;
          #enable32Bit = true;

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

      programs.gamescope.args = [ "-F fsr" ];

      services = {
        lact = {
          enable = true; # AMDGPU controller
          #settings = { };
        };
        xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
      };
    })

    (lib.mkIf (cfg.enable && cfg.uv.enable) {
      # Undervolt GPU - https://wiki.archlinux.org/title/AMDGPU#Boot_parameter
      hardware.amdgpu.overdrive = {
        enable = true;
        ppfeaturemask = lib.mkDefault "0xffffffff"; # boot.kernelParams: "amdgpu.ppfeaturemask=0x..."
      };

      powerManagement.resumeCommands = "systemctl restart amdgpu-undervolt.service"; # Restart GPU undervolt service upon resume

      # Create a service to undervolt GPU
      systemd.services.amdgpu-undervolt =
        let
          uvScript = pkgs.writeShellScriptBin "amdgpu-uv" ''
            GPU='${cfg.uv.gpu}'

            echo "Setting GPU min clock"
            echo s 0 ${toString cfg.uv.clockMin} | tee "$GPU"/pp_od_clk_voltage
            echo "Setting GPU max clock"
            echo s 1 ${toString cfg.uv.clockMax} | tee "$GPU"/pp_od_clk_voltage
            echo "Setting voltage offset"
            echo vo ${toString cfg.uv.voltOffset} | tee "$GPU"/pp_od_clk_voltage
            #echo "Setting VRAM max clock"
            #echo m 1 ${toString cfg.uv.vramClock} | tee "$GPU"/pp_od_clk_voltage
            echo "Applying undervolt settings"
            echo c | tee "$GPU"/pp_od_clk_voltage
            echo "Setting power usage limit"
            echo ${toString cfg.uv.powerLimit} | tee "$GPU"/hwmon/hwmon1/power1_cap

            # Performance level: auto, low, high, manual
            echo "Setting performance level"
            echo manual | tee "$GPU"/power_dpm_force_performance_level
            # Power level mode: cat pp_power_profile_mode
            echo "Setting power level mode to 3D Fullscreen"
            echo 1 | tee "$GPU"/pp_power_profile_mode
            # GPU power states: cat pp_dpm_sclk
            echo "Enabling all GPU power states"
            echo 2 | tee "$GPU"/pp_dpm_sclk
            # VRAM power states: cat pp_dpm_mclk
            echo "Enabling all VRAM power states"
            echo 3 | tee "$GPU"/pp_dpm_mclk
          '';
        in
        {
          after = [
            "multi-user.target"
            "rc-local.service"
            "systemd-user-sessions.service"
          ];
          description = "Set AMDGPU Undervolt";
          wantedBy = [ "multi-user.target" ];
          wants = [ "modprobe@amdgpu.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = "yes";
            ExecStart = "${lib.getExe uvScript}";
            ExecReload = "${lib.getExe uvScript}";
          };
        };
    })
  ];
}
