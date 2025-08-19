{
  lib,
  ...
}:
{
  boot = {
    # sudo btrfs inspect-internal map-swapfile -r /.swap/swapfile
    #kernelParams = [ "resume_offset=" ];
    resumeDevice = "/dev/disk/by-label/NixOS";
  };

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
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
                swap.swapfile.size = "16G";
              };
            };
          };
        };
      };
    };
  };
}
