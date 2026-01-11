{
  lib,
  pkgs,
  flk,
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
    de = {
      gnome.enable = true;
      kde.enable = false;
    };

    hw.audio.enable = false;
  };

  ##########################################################
  # System Packages / Variables
  ##########################################################
  environment = {
    systemPackages = [ ];
    variables.MOZ_DRM_DEVICE = "$(stat /dev/dri/* | grep card | cut -d':' -f 2 | tr -d ' ')"; # Set Firefox to use GPU for video codecs
  };

  # Bypass occasional login screen freeze
  services.displayManager.autoLogin = {
    enable = lib.mkForce true;
    user = flk.user;
  };

  system.stateVersion = "24.11";

  ##########################################################
  # Home Manager
  ##########################################################
  home-manager.users.${flk.user} = {
    home.stateVersion = "24.11";
  };

  ##########################################################
  # Hardware
  ##########################################################
  hardware.graphics = {
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
        libvpl
        vpl-gpu-rt
        ;
    };
    extraPackages32 = builtins.attrValues {
      inherit (pkgs.driversi686Linux)
        intel-media-driver
        intel-vaapi-driver
        ;
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

    kernelPackages = pkgs.linuxPackages;
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
    };

    supportedFilesystems = [ "btrfs" ];
  };
}
