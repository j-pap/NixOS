{
  description = "NixOS Multi-System Flake";

  inputs = {
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
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-artwork = {
      url = "github:NixOS/nixos-artwork";
      flake = false;
    };
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };


  outputs = { self, nixpkgs, ... } @ inputs: let
    overlays = [
      inputs.nur.overlays.default
    ];

    # 'nixos-rebuild switch --flake .#hostname'
    hostSystems = {
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

      # 'nix build .#nixosConfigurations.iso.config.system.build.isoImage' or 'nix build .#buildIso'
      iso = {
        isBare = true;
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
      isBare = hostOpts.isBare or false;
      sysModules = hostOpts.modules;
      specialArgs = let
        cfgTerm = "kitty";  # kitty or wezterm
        nixPath = "/etc/nixos";
      in {
        inherit
        inputs
        cfgTerm
        nixPath
        ;
      };
    in nixpkgs.lib.nixosSystem {
      modules = (if (isBare)
        then ([ ])
        else (stdModules hostName specialArgs)
      ) ++ sysModules;
      specialArgs = specialArgs;
    };

    stdModules = hostName: specialArgs: [
      ({ config, ... }: {
        _module.args = {
          cfgHosts = config.myHosts;
          cfgOpts = config.myOptions;
          myUser = config.myUser;
        };
        networking.hostName = hostName;
        nixpkgs = {
          config = {
            allowUnfree = true;
            packageOverrides = pkgs: {
              stable = import inputs.nixpkgs-stable {
                inherit system;
                config = config.nixpkgs.config;
                overlays = config.nixpkgs.overlays;
              };
            };
          };
          overlays = overlays;
        };
      })
      ./common
      ./hosts/${hostName}
      inputs.disko.nixosModules.disko
      inputs.flake-programs-sqlite.nixosModules.programs-sqlite
      inputs.home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = specialArgs;
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
      inputs.nur.modules.nixos.default
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
    ];

    system = "x86_64-linux";  # Used for inheriting nixpkgs-stable and declaring outputs.packages
  in {
    nixosConfigurations = builtins.mapAttrs mkSystem hostSystems;

    packages.${system} = {
      default = self.packages.${system}.buildIso;
      buildIso = self.nixosConfigurations.iso.config.system.build.isoImage;
    };
  };
}
