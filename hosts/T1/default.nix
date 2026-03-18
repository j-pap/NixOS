{
  config,
  lib,
  pkgs,
  flk,
  inputs,
  ...
}:
let
  m4b-tool = inputs.m4b-tool.packages.${pkgs.stdenv.hostPlatform.system}.m4b-tool;
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
    openrgb.enable = true;
    protonmail.enable = true;
    syncthing.enable = true;
    vm.enable = true;
    yubikey.enable = true;

    terminal = "kitty";

    de = {
      #cosmic.enable = true;
      #hyprland.enable = true;
      kde = {
        enable = true;
        gpuWidget = "gpu/gpu1/temperature";
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
      m4b-tool # Audiobook manipulation
    ]
    ++ builtins.attrValues {
      inherit (pkgs)
        # Browser
        brave # Alt

        # Communication
        signal-desktop # Signal
        thunderbird-latest # Email client

        # Misc
        android-tools # Android flashing

        # Multimedia
        calibre # Book organization
        flacon # CUE converter
        mp4v2 # Audiobook chapters | `mp4chaps -l`
        picard # Music tagger
        #pocket-casts # Podcast player
        tauon # Music player
        tidal-dl # Tidal downloader
        tidal-hifi # Tidal client

        # Productivity
        libreoffice-qt6-fresh # Office suite
        obsidian # Markdown notes
        ;
      inherit (pkgs.openraPackages_2019.engines)
        #bleed # Command & Conquer | openra
        ;
    }
    ++ lib.optionals (config.hardware.openrazer.enable) [
      pkgs.polychromatic # Razer lighting GUI
    ];

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
      };
    };
  };

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

    home.stateVersion = "24.11";
  };

  ##########################################################
  # Hardware
  ##########################################################
  hardware = {
    fancontrol = {
      enable = true;
      config = import ./fancontrol.nix { inherit config; };
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
  # Boot
  ##########################################################
  boot = {
    initrd.systemd.enable = true;

    blacklistedKernelModules = [
      "amdgpu" # iGPU
      "mt7921e" # Wifi
    ];
    extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
    kernelModules = [
      "nct6687"
      "nfs"
    ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
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
