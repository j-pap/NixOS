{
  lib,
  ...
}:
{
  boot = {
    # sudo btrfs inspect-internal map-swapfile -r /.swap/swapfile
    kernelParams = [ "resume_offset=533760" ];
    resumeDevice = "/dev/disk/by-label/NixOS";
  };

  disko.devices.disk.nvme = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          label = "boot";
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        ROOT = {
          label = "root";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [
              "--force"
              "--label NixOS"
            ];
            subvolumes = let
              defaultOptions = [
                "compress=zstd"
                "discard=async"
                "noatime"
              ];
            in {
              "root" = {
                mountOptions = defaultOptions;
                mountpoint = "/";
              };
              "home" = {
                mountOptions = lib.remove "noatime" defaultOptions;
                mountpoint = "/home";
              };
              "nix" = {
                mountOptions = defaultOptions;
                mountpoint = "/nix";
              };
              "swap" = {
                mountpoint = "/.swap";
                swap.swapfile.size = "32G";
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/mnt/nas" = {
    device = "rm21:/mnt/user";
    fsType = "nfs";
    options = [
      "_netdev"
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.idle-timeout=10m"
      "x-systemd.mount-timeout=5s"
    ];
  };
}
