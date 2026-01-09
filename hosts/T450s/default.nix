{
  lib,
  pkgs,
  flk,
  myUser,
  ...
}:
{
  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  ##########################################################
  # Custom Options
  ##########################################################
  flake = {
    "1password".enable = true;

    de = {
      #cosmic.enable = true;
      hyprland.enable = true;
    };

    hw.bluetooth.enable = false;

    host = {
      isLaptop = true;
      monitor = {
        name = "eDP-1";
        width = "1920";
        height = "1080";
        refresh = "60";
        scale = "1.25";
      };
      theme = {
        #dark = "";
        #light = "";
      };
      wallpaper = {
        dark = ./wallpaper/dark.png;
        light = ./wallpaper/light.png;
        #login = ./wallpaper/login.png;
      };
    };
  };

  ##########################################################
  # System Packages / Variables
  ##########################################################
  environment = {
    systemPackages = [
      pkgs.nvtopPackages.intel
    ];
    variables.MOZ_DRM_DEVICE = "/dev/dri/by-path/pci-0000:00:02.0-render"; # Set Firefox to use GPU for video codecs
  };

  system.stateVersion = "24.11";

  ##########################################################
  # Home Manager
  ##########################################################
  home-manager.users.${myUser} = {

    programs = {
      plasma = lib.mkIf (flk.de.kde.enable) {
        configFile."kcminputrc"."Libinput/1739/0/Synaptics TM3053-004" = {
          "ClickMethod" = 2;
          "NaturalScroll" = true;
          "PointerAccelerationProfile" = 1;
          "ScrollFactor" = 0.5;
          "TapDragLock" = true;
        };
      };

      waybar.settings = lib.mkIf (flk.de.hyprland.enable) {
        mainBar =
          let
            batteryCount = 2;
          in
          {
            "temperature#cpu".hwmon-path = "/sys/class/hwmon/hwmon6/temp1_input";
            "temperature#gpu".hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";

            modules-right = lib.mkAfter (
              builtins.concatLists (builtins.genList (i: [ "battery\#bat${toString i}" ]) batteryCount)
            );
          }
          // builtins.listToAttrs (
            builtins.genList (i: {
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
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
                format-charging = "󱐋 {capacity}%";
                format-plugged = " {capacity}%";
                tooltip = true;
                tooltip-format = "{time}";
              };
            }) batteryCount
          );
      };
    };

    wayland.windowManager.hyprland = lib.mkIf (flk.de.hyprland.enable) {
      settings.bindd = [
        #", XF86Display, Presentation mode, , "
        #", XF86WLAN, Airplane mode, , " # Disables wifi by default
        #", XF86Tools, Settings, , "
        #", XF86Search, App search, , "
        #", XF86LaunchA, App launcher, exec, rofi -show drun"
        #", XF86Explorer, File explorer, exec, kitty spf"
      ];
    };

    home.stateVersion = "24.11";
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
  # Network
  ##########################################################

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
}
