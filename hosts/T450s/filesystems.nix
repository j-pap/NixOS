{
  lib,
  ...
}:
{
  disko.devices.disk.sda = {
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
            };
          };
        };
      };
    };
  };
}
