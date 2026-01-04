{
  config,
  lib,
  pkgs,
  myUser,
  ...
}:
let
  cfg = config.flake.containers;
in
{
  options.flake.containers = {
    enable = lib.mkEnableOption "Containers";
    docker = lib.mkEnableOption "Docker";
    podman = lib.mkEnableOption "Podman";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable) {
      assertions = [
        {
          assertion = !(cfg.docker && cfg.podman);
          message = "Docker and Podman may not be used at the same time.";
        }
      ];

      flake.containers.docker = lib.mkDefault true;

      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          # Docker
          compose2nix
          # Kubernetes Tools
          #kind
          #kubectl
          ;
      };

      virtualisation.containers.enable = true;
    })

    (lib.mkIf (cfg.enable && cfg.docker) {
      users.users.${myUser}.extraGroups = [ "docker" ];

      virtualisation = {
        oci-containers.backend = "docker";
        docker = {
          enable = true;
          autoPrune = { };
          daemon.settings = {
            data-root = "/var/lib/docker";
            #default-address-pools = [ ];
            #dns = [ ];
            ipv6 = lib.mkIf (config.networking.enableIPv6) true;
            live-restore = true;
            log-driver = "journald";
            storage-driver = "btrfs";
          };
          rootless = {
            #enable = true;
            #daemon.settings = { };
            #setSocketVariable = true;
          };
        };
      };
    })

    (lib.mkIf (cfg.enable && cfg.podman) {
      users.users.${myUser}.extraGroups = [ "podman" ];

      virtualisation = {
        oci-containers.backend = "podman";
        podman = {
          enable = true;
          autoPrune = { };
          dockerCompat = true; # Docker alias
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    })
  ];
}
