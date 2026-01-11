{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  protonMB = pkgs.protonmail-bridge-gui; # pkgs or pkgs.stable
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
    # "1password", gaming, openrgb, syncthing, vm, yubikey
    "1password".enable = true;
    gaming.enable = true;
    syncthing.enable = true;
    vm.enable = true;
    yubikey.enable = true;

    terminal = "kitty";

    de = {
      hyprland.enable = false;
      kde = {
        enable = true;
        gpuWidget = "gpu/gpu0/temperature";
      };
    };

    hw = {
      bluetooth.enable = false;
      nvidia.enable = true;
    };

    host = {
      monitor = {
        #name = "eDP-1";
        width = "2560";
        height = "1440";
        refresh = "144";
        scale = "1.25";
      };
      theme = {
        #dark = "";
        #light = "";
      };
      wallpaper = {
        dark = ./wallpaper/dark.png;
        light = ./wallpaper/light.png;
        login = ./wallpaper/login.png;
      };
    };
  };

  ##########################################################
  # System Packages / Variables
  ##########################################################
  environment = {
    systemPackages = [
      protonMB # GUI bridge for Thunderbird
    ]
    ++ builtins.attrValues {
      inherit (pkgs)
        # Browser
        brave                 # Alt

        # Communication
        discord               # Discord
        signal-desktop        # Signal
        thunderbird-latest    # Email client

        # Hardware
        polychromatic         # Razer lighting GUI

        # Misc
        android-tools         # Android flashing
        calibre               # Book organization

        # Multimedia
        flacon                # CUE converter
        picard                # Music tagger
        pocket-casts          # Podcast player
        tauon                 # Music player
        tidal-dl              # Tidal downloader
        tidal-hifi            # Tidal client

        # Productivity
        libreoffice-qt6-fresh # Office suite
        obsidian              # Markdown notes
        ;

      inherit (pkgs.openraPackages_2019.engines)
        bleed # Command & Conquer | openra
        ;
    };
    variables = {
      MOZ_DRM_DEVICE = "/dev/dri/by-path/pci-0000:01:00.0-render"; # Nvidia
      #MOZ_DRM_DEVICE = "/dev/dri/by-path/pci-0000:0d:00.0-render"; # AMD
    };
  };

  programs = {
    coolercontrol.enable = lib.mkIf (!config.hardware.fancontrol.enable) true;

    gamescope = {
      args = [
        "--prefer-vk-device \"10de:2684\"" # `lspci -nn | grep -i vga`
        "--hdr-enabled"
      ];
      env = {
        DXVK_HDR = "1";
        ENABLE_GAMESCOPE_WSI = "1"; # Not sure if required w/ pkgs.gamescope-wsi
      };
    };
  };

  services.fwupd.enable = true;

  users.users.${flk.user}.extraGroups = [ "fancontrol" ];

  system.stateVersion = "24.11";

  ##########################################################
  # Home Manager
  ##########################################################
  home-manager.users.${flk.user} = {

    programs.mangohud.settings = {
      gpu_voltage = true;
      gpu_fan = true;
      pci_dev = "0:01:00.0"; # `lspci -D | grep -i vga`
      table_columns = lib.mkForce 6;
    };

    xdg.configFile."autostart/ProtonMailBridge.desktop".text = (
      lib.replaceStrings [ "Exec=protonmail-bridge-gui" ] [ "Exec=${lib.getExe protonMB} --no-window" ] (
        lib.fileContents "${protonMB}/share/applications/proton-bridge-gui.desktop"
      )
    );

    home.stateVersion = "24.11";
  };

  ##########################################################
  # Hardware
  ##########################################################
  hardware = {
    fancontrol = {
      enable = true;
      config =
        let
          # Hardware
          cpuMon = "hwmon1";
          cpuName = "k10temp";
          cpuPath = "devices/pci0000:00/0000:00:18.3";
          fanMon = "hwmon4";
          fanName = "nct6686";
          fanPath = "devices/platform/nct6687.2592";
          # Fan speeds -- value = percent * 2.55
          caseMin = "100"; # 40%
          caseMax = "102"; # 40%
          cpuMin = "64"; # 25%
          cpuMax = "217"; # 85%
        in
        ''
          INTERVAL=10
          DEVPATH=${cpuMon}=${cpuPath} ${fanMon}=${fanPath}
          DEVNAME=${cpuMon}=${cpuName} ${fanMon}=${fanName}
          FCTEMPS=${fanMon}/pwm1=${cpuMon}/temp1_input ${fanMon}/pwm2=${cpuMon}/temp1_input
          FCFANS=${fanMon}/pwm1=${fanMon}/fan1_input ${fanMon}/pwm2=${fanMon}/fan2_input
          MINTEMP=${fanMon}/pwm1=40 ${fanMon}/pwm2=40
          MAXTEMP=${fanMon}/pwm1=80 ${fanMon}/pwm2=80
          MINSTART=${fanMon}/pwm1=30 ${fanMon}/pwm2=30
          MINSTOP=${fanMon}/pwm1=${cpuMin} ${fanMon}/pwm2=${caseMin}
          # Fans @ 25%/40% until 40 degress
          MINPWM=${fanMon}/pwm1=${cpuMin} ${fanMon}/pwm2=${caseMin}
          # CPU fan ramps to 85% @ 80 degrees
          MAXPWM=${fanMon}/pwm1=${cpuMax} ${fanMon}/pwm2=${caseMax}
        '';
    };

    nvidia.prime = {
      amdgpuBusId = "PCI:13:0:0";
      nvidiaBusId = "PCI:1:0:0";
      #reverseSync.enable = true;
    };

    openrazer = {
      enable = true;
      users = [ flk.user ];
    };
  };

  ##########################################################
  # Network
  ##########################################################

  ##########################################################
  # Boot
  ##########################################################
  boot = {
    initrd.systemd.enable = true;

    blacklistedKernelModules = [
      "amdgpu" # Disable iGPU
    ];
    extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
    kernelModules = [
      "nct6687"
      "nfs"
    ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
    kernelParams = [
      "amd_pstate=active"
      "module_blacklist=amdgpu"
    ];

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
      timeout = 2;
    };

    plymouth = {
      enable = false;
      theme = "loader"; # Previews: https://github.com/adi1090x/plymouth-themes
      themePackages = [
        # Overriding installs a single theme instead of all 80, reducing the required size
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "${config.boot.plymouth.theme}" ];
        })
      ];
    };

    supportedFilesystems = [
      "btrfs"
      "nfs"
    ];
  };
}
