{
  config,
  lib,
  pkgs,
  flk,
  inputs,
  ...
}:
let
  useFP = true; # Whether or not to enable the fingerprint reader

  # Patch kernel to log usbpd instead of warn
  fw-usbpd-charger = pkgs.callPackage ./usbpd {
    kernel = config.boot.kernelPackages.kernel;
  };
in
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
    containers.enable = true;
    gaming.enable = true;
    protonmail.enable = true;
    protonvpn.enable = true;
    #stylix.enable = true;
    syncthing.enable = true;
    vm.enable = true;
    yubikey.enable = true;

    terminal = "kitty";

    de = {
      #cosmic.enable = true;
      gnome.enable = true;
    };

    hw = {
      amdgpu.enable = true;
      bluetooth.enable = true;
    };

    host = {
      isLaptop = true;
      monitor = {
        #name = "";
        width = "2256";
        height = "1504";
        refresh = "60";
        scale = "1.3333333730697632";
      };
      theme = {
        #dark = "";
        #light = "";
      };
      wallpaper = {
        #dark = ./wallpaper/dark.png;
        #light = ./wallpaper/light.png;
        #login = ./wallpaper/login.png;
      };
    };
  };

  ##########################################################
  # System Packages / Variables
  ##########################################################
  environment = {
    systemPackages =
      let
        s2idle = pkgs.callPackage ./s2idle.nix { };
      in
      [
        s2idle # Environment for suspend testing | 's2idle ./amd_s2idle.py'
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # Browser
          brave # Alt

          # Communication
          signal-desktop # Signal
          thunderbird-latest # Email client

          # Framework Hardware
          framework-tool # Swiss army knife for FWs
          sbctl # Secure boot key manager

          # Misc
          android-tools # Android flashing

          # Monitoring
          powertop # Power stats
          zenmonitor # CPU stats

          # Multimedia
          flacon # CUE converter
          picard # Music tagger
          #pocket-casts # Podcast player
          tauon # Music player
          tidal-dl # Tidal downloader
          tidal-hifi # Tidal client

          # Productivity
          libreoffice-fresh # Office suite
          obsidian # Markdown notes
          ;
      };
    variables.MOZ_DRM_DEVICE = "/dev/dri/by-path/pci-0000:c1:00.0-render"; # Set Firefox to use GPU for video codecs
  };

  programs.gamescope.args = [ "--prefer-vk-device \"1002:15bf\"" ]; # `lspci -nn | grep -i vga`

  system.stateVersion = "24.11";

  ##########################################################
  # Home Manager
  ##########################################################
  home-manager.users.${flk.user} =
    let
      easyPreset = "fw13-easy-effects";
    in
    {
      #imports = [ ./fetch-logo.nix ];

      programs.mangohud.settings.pci_dev = "0:c1:00.0"; # `lspci -D | grep -i vga`

      services.easyeffects = {
        enable = true;
        preset = easyPreset;
      };

      xdg.configFile = {
        # https://github.com/FrameworkComputer/linux-docs/tree/main/easy-effects
        "easyeffects/output/${easyPreset}.json".source =
          inputs.framework-cpu + "/easy-effects/${easyPreset}.json";
        "easyeffects/irs/IR_22ms_27dB_5t_15s_0c.irs".source =
          inputs.framework-cpu + "/easy-effects/irs/IR_22ms_27dB_5t_15s_0c.irs";
      };

      home.stateVersion = "24.11";
    };

  ##########################################################
  # Hardware
  ##########################################################
  hardware = {
    bluetooth.powerOnBoot = lib.mkForce false;
    enableAllFirmware = true;
    firmware = [ pkgs.linux-firmware ];
    sensor.iio.enable = true; # Ambient light sensor | 'monitor-sensor'
    wirelessRegulatoryDatabase = true; # Allow 5GHz wifi
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true; # Auto-tuning - to use powertop bin, pkg must be declared in systemPackages
  };

  services = {
    fprintd.enable = lib.mkForce useFP; # 'sudo fprintd-enroll'

    #fwupd.extraRemotes = ["lvfs-testing"];

    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "suspend-then-hibernate";
      IdleAction = "suspend";
      IdleActionSec = "10m";
    };

    udev.extraRules =
      let
        # GPU performance adjusts based upon power input
        gpuPowerMode = pkgs.writeShellScriptBin "gpu-power" ''
          GPU=$(readlink -f /sys/class/drm/card?/device)
          echo "$1" > "$GPU"/power_dpm_force_performance_level
        '';
      in
      ''
        ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${lib.getExe gpuPowerMode} low"
        ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${lib.getExe gpuPowerMode} high"
      '';

    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 10;
      percentageAction = 5;
      criticalPowerAction = "Hibernate";
    };
  };

  # Sleep for 30m then hibernate
  systemd.sleep.extraConfig = ''
    AllowHibernation=yes
    HibernateDelaySec=30m
    HibernateMode=shutdown
    SuspendState=mem
  '';

  ##########################################################
  # Network
  ##########################################################
  networking = {
    enableIPv6 = false;
    firewall.checkReversePath = "loose";
    networkmanager.wifi = {
      backend = "iwd"; # iwd performs better on AMD FW models
      macAddress = "stable-ssid";
      powersave = false;
    };
  };

  ##########################################################
  # Boot
  ##########################################################
  boot = {
    initrd = {
      availableKernelModules = [ "cryptd" ];
      systemd.enable = true;
    };

    blacklistedKernelModules = [
      #"framework_laptop" # Taints kernel when debugging w/ amd_s2idle
    ];
    extraModprobeConfig = ''
      # Enable 5GHz
      options cfg80211 ieee80211_regdom="US"
      # Fix wifi high latency
      options mt7921e disable_aspm=1
    '';
    extraModulePackages = [
      fw-usbpd-charger # Taints kernel when debugging w/ amd_s2idle
    ];
    kernelModules = [
      "nfs"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_iommu=off" # Fixes VP9/VAAPI video glitches
      "ipv6.disable=1"
    ];

    # https://nix-community.github.io/lanzaboote/
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = if (config.boot.lanzaboote.enable) then lib.mkForce false else true;
        configurationLimit = 5;
        consoleMode = "auto";
        editor = false;
        memtest86.enable = config.boot.loader.systemd-boot.enable;
      };
      timeout = 2;
    };

    plymouth = {
      enable = true;
      theme = "framework";
      themePackages = [ pkgs.framework-plymouth ];
    };

    supportedFilesystems = [
      "btrfs"
      "nfs"
    ];
  };
}
