{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.flake.k8s;
in
{
  options.flake.k8s.enable = lib.mkEnableOption "Kubernetes";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        # K3s
        # k3s # Lightweight k8s
        # nerdctl # CLI for containerd (k3s)

        # K8s
        kubectl # k8s CLI
        # kubernetes # k8s management
        # kind # k8s in docker
        # minikube # k8s using VM
        # talosctl # Talos
        ;
    };

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/README.md
    # services.k3s.enable = true;
  };
}
