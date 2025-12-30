{
  lib,
  pkgs,
  cfgHosts,
  cfgOpts,
  myUser,
  ...
}: {
  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  ##########################################################
  # Custom Options
  ##########################################################
  myHosts = {
    width = 1920;
    height = 1080;
    refresh = 60;
    scale = 1.25;
  };

  myOptions = {
    desktops = {
      #cosmic.enable = true;
      hyprland.enable = true;
    };

    hardware.bluetooth.enable = false;

    # "1password", kitty, wezterm
    "1password".enable = true;
  };


  ##########################################################
  # System Packages / Variables
  ##########################################################
  environment = {
    systemPackages = [
      pkgs.nvtopPackages.intel
    ];
    # Set Firefox to use GPU for video codecs
    variables.MOZ_DRM_DEVICE = "/dev/dri/by-path/pci-0000:00:02.0-render";
  };

  system.stateVersion = "24.11";


  ##########################################################
  # Home Manager
  ##########################################################
  home-manager.users.${myUser} = {
    home.stateVersion = "24.11";

    programs = {
      plasma = lib.mkIf (cfgOpts.desktops.kde.enable) {
        configFile."kcminputrc"."Libinput/1739/0/Synaptics TM3053-004" = {
          "ClickMethod" = 2;
          "NaturalScroll" = true;
          "PointerAccelerationProfile" = 1;
          "ScrollFactor" = 0.5;
          "TapDragLock" = true;
        };
      };

      waybar.settings = lib.mkIf (cfgOpts.desktops.hyprland.enable) {
        mainBar = let
          batteryCount = 2;
        in {
          "temperature#cpu".hwmon-path = "/sys/class/hwmon/hwmon6/temp1_input";
          "temperature#gpu".hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";

          modules-right = lib.mkAfter (builtins.concatLists (
            builtins.genList (i: [ "battery\#bat${toString i}" ]) batteryCount
          ));
        } // 
        builtins.listToAttrs (
          builtins.genList (
            i: {
              name = "battery#bat${toString i}";
              value = {
                bat = "BAT${toString i}";
                adapter = "AC";
                interval = 5;
                states = {
                  warning = 25;
                  critical = 10;
                };
                format = "<span size='15pt' rise='-3000'>{icon}</span> {capacity}%";
                format-time = "{H}h:{M}m";
                format-icons = [ "" "" "" "" "" ];
                format-charging = "󱐋 {capacity}%";
                format-plugged = " {capacity}%";
                tooltip = true;
                tooltip-format = "{time}";
              };
            }
          ) batteryCount
        );
      };
    };

    wayland.windowManager.hyprland = lib.mkIf (cfgOpts.desktops.hyprland.enable) {
      settings = let
        name = "eDP-1";
        width = builtins.toString cfgHosts.width;
        height = builtins.toString cfgHosts.height;
        refresh = builtins.toString cfgHosts.refresh;
        scale = builtins.toString cfgHosts.scale;
      in {
        monitor = [ "${name}, ${width}x${height}@${refresh}, 0x0, ${scale}" ];
        bindd = [
          #", XF86Display, Presentation mode, , "
          #", XF86WLAN, Airplane mode, , " # Disables wifi by default
          #", XF86Tools, Settings, , "
          #", XF86Search, App search, , "
          #", XF86LaunchA, App launcher, exec, rofi -show drun"
          #", XF86Explorer, File explorer, exec, kitty spf"
        ];
      };
    };
  };


  ##########################################################
  # Hardware
  ##########################################################
  hardware.graphics = {
    # Packages (listed for context) are imported from nixos-hardware/common/gpu/intel through T450s module
    /*
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
        vpl-gpu-rt
      ;
    };
    extraPackages32 = builtins.attrValues {
      inherit (pkgs.driversi686Linux)
        intel-media-driver
        intel-vaapi-driver
      ;
    };
    */
  };


  ##########################################################
  # Boot
  ##########################################################
  boot = {
    initrd.systemd.enable = true;

    kernelModules = [ "nfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "auto";
        editor = false;
        memtest86.enable = true;
      };
      timeout = 1;
    };

    plymouth = {
      enable = false;
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
    };

    supportedFilesystems = [
      "btrfs"
      "nfs"
    ];
  };


  ##########################################################
  # Network
  ##########################################################
}
