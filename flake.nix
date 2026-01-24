{
  description = "NixOS Systems Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";
    ###
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    disko.url = "github:nix-community/disko";
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    framework-plymouth.url = "github:j-pap/framework-plymouth";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprshutdown.url = "github:hyprwm/hyprshutdown";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixvim.url = "github:nix-community/nixvim";
    nur.url = "github:nix-community/NUR";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix.url = "github:Mic92/sops-nix";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      stable,
      ...
    }@inputs:
    let
      # 'nixos-rebuild switch --flake .#hostname'
      hosts = {
        /*
          Dekki.modules = [
            inputs.jovian.nixosModules.jovian
          ];
        */

        FW13.modules = [
          {
            nixpkgs.overlays = [
              inputs.framework-plymouth.overlays.default
            ];
          }
          inputs.hardware.nixosModules.framework-13-7040-amd
          inputs.lanzaboote.nixosModules.lanzaboote
        ];

        # 'nix build .#nixosConfigurations.iso.config.system.build.isoImage'
        iso = {
          hostIsBare = true;
          modules = [
            ./hosts/iso
          ];
        };

        /*
          Ridge.modules = [
            inputs.jovian.nixosModules.jovian
          ];
        */

        T1.modules = [ ];

        T450s.modules = [
          inputs.hardware.nixosModules.lenovo-thinkpad-t450s
        ];

        VM.modules = [ ];
      };

      mkSystem =
        hostName: hostArgs:
        let
          hostIsBare = hostArgs.hostIsBare or false;
          hostModules = hostArgs.modules;
          specialArgs = { inherit inputs; };
        in
        nixpkgs.lib.nixosSystem {
          modules = (if (hostIsBare) then ([ ]) else (stdModules hostName specialArgs)) ++ hostModules;
          specialArgs = specialArgs;
        };

      stdModules = hostName: specialArgs: [
        (
          { config, ... }:
          {
            _module.args = {
              flk = config.flake;
            };
            networking.hostName = hostName;
            nixpkgs = {
              config = {
                allowUnfree = true;
                packageOverrides = pkgs: {
                  stable = import stable {
                    inherit (pkgs.stdenv.hostPlatform) system;
                    inherit (pkgs) overlays;
                    config.allowUnfree = true;
                  };
                };
              };
              overlays = (map import (import ./overlays)) ++ [
                inputs.nix-cachyos-kernel.overlays.default
                inputs.nur.overlays.default
              ];
            };
          }
        )
        ./hosts/${hostName}
        ./base
        inputs.disko.nixosModules.disko
        inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            sharedModules = [
              inputs.cosmic-manager.homeManagerModules.cosmic-manager
              inputs.plasma-manager.homeModules.plasma-manager
            ];
          };
        }
        inputs.nur.modules.nixos.default
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
      ];
    in
    {
      nixosConfigurations = builtins.mapAttrs mkSystem hosts;
    };
}
