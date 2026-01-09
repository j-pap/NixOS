{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.vm;
in
{
  options.flake.vm.enable = lib.mkEnableOption "QEMU/KVM";

  config = lib.mkIf (cfg.enable) {
    programs.virt-manager.enable = true;

    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true; # Shared clipboard
    };

    users.users.${flk.user}.extraGroups = [
      "libvirtd"
      "qemu-libvirtd"
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [
        pkgs.virtiofsd # Shared directories
      ];
    };
  };
}
