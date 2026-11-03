{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  b650 = false;
  latestKernel = false;
  nvidiaGpu = false;
  zfsModule = false;
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    # (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix")
  ];

  config = lib.mkMerge [
    {
      boot = {
        kernelModules = lib.optionals (b650) [
          "nct6687"
        ];
        extraModulePackages = lib.optionals (b650) builtins.attrValues {
          inherit (config.boot.kernelPackages)
            nct6687d
            ;
        };
        kernelPackages = if (!latestKernel) then pkgs.linuxPackages else pkgs.linuxPackages_latest;
      };

      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          coreutils
          git
          lm_sensors
          lshw
          pciutils
          sops
          ssh-to-age
          tree
          usbutils
          vim
          wget
          ;
      };

      isoImage.squashfsCompression = "gzip";

      nix.settings = {
        download-buffer-size = 536870912; # 512MB in Bytes
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      nixpkgs = {
        config = {
          allowBroken = zfsModule; # Bypass potential broken ZFS module
          allowUnfree = true;
        };
        hostPlatform = lib.mkDefault "x86_64-linux";
      };

      time.timeZone = lib.mkDefault "America/Chicago";

      users.users.nixos = {
        isNormalUser = true;
        initialHashedPassword = lib.mkForce null;
        password = "nixos";
      };
    }

    (lib.mkIf (nvidiaGpu) {
      hardware = {
        graphics.enable = true;
        nvidia =
          let
            release = if (latestKernel) then "latest" else "stable";
            nvPkg = config.boot.kernelPackages.nvidiaPackages.${release};
            nvDrvr = if (config.hardware.nvidia.open) then "open" else "bin";
          in
          {
            modesetting.enable = true;
            nvidiaSettings = false;
            open = true;
            package = nvPkg // {
              ${nvDrvr} = nvPkg.${nvDrvr};
            };
          };
      };

      services.xserver.videoDrivers = [ "nvidia" ];
    })
  ];
}
