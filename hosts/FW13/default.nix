{
  config,
  lib,
  pkgs,
  flk,
  myUser,
  ...
}:
let
  useFP = true; # Whether or not to enable the fingerprint reader

  # Patch kernel to log usbpd instead of warn
  fw-usbpd-charger = pkgs.callPackage ./usbpd {
    kernel = config.boot.kernelPackages.kernel;
  };

  # pkgs or pkgs.stable
  protonMB = pkgs.protonmail-bridge-gui;
  protonVPN = pkgs.stable.protonvpn-gui;
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
    # "1password", containers, gaming, stylix, syncthing, vm, yubikey
    "1password".enable = true;
    containers.enable = true;
    gaming.enable = true;
    stylix.enable = false;
    syncthing.enable = true;
    vm.enable = true;
    yubikey.enable = true;

    de = {
      cosmic.enable = false;
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
        scale = 1.25;
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
        protonMB  # GUI bridge for Thunderbird
        protonVPN # VPN client
        s2idle    # Environment for suspend testing | 's2idle ./amd_s2idle.py'
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # Browser
          brave               # Alt

          # Communication
          discord             # Discord
          signal-desktop      # Signal
          thunderbird-latest  # Email client

          # Framework Hardware
          framework-tool      # Swiss army knife for FWs
          iio-sensor-proxy    # Ambient light sensor | 'monitor-sensor'
          sbctl               # Secure boot key manager

          # Monitoring
          powertop            # Power stats
          zenmonitor          # CPU stats

          # Multimedia
          flacon              # CUE converter
          picard              # Music tagger
          pocket-casts        # Podcast player
          tauon               # Music player
          tidal-dl            # Tidal downloader
          tidal-hifi          # Tidal client

          # Productivity
          libreoffice-fresh   # Office suite
          obsidian            # Markdown notes
          ;
      };
    variables = {
      MOZ_DRM_DEVICE = "/dev/dri/by-path/pci-0000:c1:00.0-render"; # Set Firefox to use GPU for video codecs
      TERMINAL = "kitty";
    };
  };

  programs = {
    adb.enable = true; # Android flashing
    gamescope.args = [ "--prefer-vk-device \"1002:15bf\"" ]; # `lspci -nn | grep -i vga`
  };

  system.stateVersion = "24.11";

  ##########################################################
  # Home Manager
  ##########################################################
  home-manager.users.${myUser} =
    let
      easyPreset = "fw13-easy-effects";
    in
    {
      #imports = [ ./fetch-logo.nix ];

      dconf.settings."org/gnome/settings-daemon/plugins/power".ambient-enabled = false; # Auto screen brightness

      programs.mangohud.settings.pci_dev = "0:c1:00.0"; # `lspci -D | grep -i vga`

      services.easyeffects = {
        enable = true;
        preset = easyPreset;
      };

      xdg.configFile =
        let
          fwRepo = pkgs.fetchFromGitHub {
            owner = "FrameworkComputer";
            repo = "linux-docs";
            rev = "5f840849623f019b433e5c9d9e8a7d4c55add809";
            sha256 = "sha256-cfP2Ykrcxylesl/cuKDSj6XcVPE51CDCT+0sC01iFBg=";
          };
        in
        {
          "autostart/ProtonMailBridge.desktop".text = lib.concatLines [
            (lib.replaceStrings [ "Exec=protonmail-bridge-gui" ] [ "Exec=${lib.getExe protonMB} --no-window" ]
              (lib.fileContents
              "${protonMB}/share/applications/proton-bridge-gui.desktop")
            )
            "X-GNOME-Autostart-enabled=true"
          ];

          "autostart/ProtonVPN.desktop".text = lib.concatLines [
            (lib.replaceStrings [ "Exec=protonvpn-app" ] [ "Exec=${lib.getExe protonVPN} --start-minimized" ]
              (lib.fileContents
              "${protonVPN}/share/applications/protonvpn-app.desktop")
            )
            "X-GNOME-Autostart-enabled=true"
          ];

          # https://github.com/FrameworkComputer/linux-docs/tree/main/easy-effects
          "easyeffects/output/${easyPreset}.json".source = fwRepo + "/easy-effects/${easyPreset}.json";
          "easyeffects/irs/IR_22ms_27dB_5t_15s_0c.irs".source =
            fwRepo + "/easy-effects/irs/IR_22ms_27dB_5t_15s_0c.irs";

          # Set GNOME fractional scaling
          "monitors.xml" = lib.mkIf (flk.de.gnome.enable) {
            text = ''
              <monitors version="2">
                <configuration>
                  <layoutmode>logical</layoutmode>
                  <logicalmonitor>
                    <x>0</x>
                    <y>0</y>
                    <scale>1.2512478828430176</scale>
                    <primary>yes</primary>
                    <monitor>
                      <monitorspec>
                        <connector>eDP-1</connector>
                        <vendor>BOE</vendor>
                        <product>0x0bca</product>
                        <serial>0x00000000</serial>
                      </monitorspec>
                      <mode>
                        <width>${flk.host.monitor.width}</width>
                        <height>${flk.host.monitor.height}</height>
                        <rate>59.999</rate>
                      </mode>
                    </monitor>
                  </logicalmonitor>
                </configuration>
              </monitors>
            '';
          };
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
    wirelessRegulatoryDatabase = true; # Allow 5GHz wifi
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true; # Auto-tuning - to use powertop bin, pkg must be declared in systemPackages
  };

  services = {
    # 'sudo fprintd-enroll'
    fprintd.enable = if (useFP) then lib.mkForce true else lib.mkForce false;

    fwupd = {
      enable = true;
      #extraRemotes = ["lvfs-testing"];
    };

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
      "dummy" # Wireguard fix - https://github.com/ProtonVPN/proton-vpn-gtk-app/issues/57#issuecomment-2994148066
      "nfs"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_iommu=off" # Fixes VP9/VAAPI video glitches
      "ipv6.disable=1"
    ];

    # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
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
