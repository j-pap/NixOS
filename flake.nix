{
  description = "NixOS Multi-System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
    ###
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
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
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
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
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs = { self, nixpkgs, stable, ... } @ inputs: let
    # 'nixos-rebuild switch --flake .#hostname'
    hosts = {
      /*
      Dekki.modules = [
        inputs.chaotic.nixosModules.default
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
        inputs.chaotic.nixosModules.default
        inputs.jovian.nixosModules.jovian
      ];
      */

      T1.modules = [
        inputs.chaotic.nixosModules.default
      ];

      T450s.modules = [
        inputs.hardware.nixosModules.lenovo-thinkpad-t450s
      ];

      VM.modules = [ ];
    };


    mkSystem = hostName: hostOpts: let
      hostIsBare = hostOpts.hostIsBare or false;
      hostModules = hostOpts.modules;
      specialArgs = { inherit inputs; };
    in nixpkgs.lib.nixosSystem {
      modules = (
        if (hostIsBare) then
          ([ ])
        else
          (stdModules hostName specialArgs)
      ) ++ hostModules;
      specialArgs = specialArgs;
    };


    stdModules = hostName: specialArgs: [
      ./common
      ./hosts/${hostName}
      ({ config, ... }: {
        _module.args = {
          cfgHosts = config.myHosts;
          cfgOpts = config.myOptions;
          cfgTerm = "kitty";  # kitty or wezterm
          myUser = config.myUser;
        };
        networking.hostName = hostName;
        nixpkgs = {
          config = {
            allowUnfree = true;
            packageOverrides = pkgs: {
              stable = import stable {
                inherit (pkgs) config overlays system;
              };
            };
          };
          overlays = [
            (import ./overlays.nix)
            inputs.nur.overlays.default
          ];
        };
      })
      inputs.disko.nixosModules.disko
      inputs.flake-programs-sqlite.nixosModules.programs-sqlite
      inputs.home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = specialArgs;
          sharedModules = [
            inputs.plasma-manager.homeModules.plasma-manager
          ];
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
      inputs.nur.modules.nixos.default
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
    ];
  in {
    nixosConfigurations = builtins.mapAttrs mkSystem hosts;
  };
}
