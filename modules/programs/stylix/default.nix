{
  config,
  lib,
  pkgs,
  cfgOpts,
  inputs,
  myUser,
  ...
}: let
  cfg = cfgOpts.stylix;

  base16 = "${pkgs.base16-schemes}/share/themes";
  switch-mode = pkgs.callPackage ./switch-mode.nix { };
  theme = {
    dark = cfg.theme.dark;
    light = cfg.theme.light;
  };
  wallpaper = {
    dark = cfg.wallpaper.dark;
    light = cfg.wallpaper.light;
  };
in {
  options.myOptions.stylix = {
    enable = lib.mkEnableOption "Stylix";
    theme = {
      dark = lib.mkOption {
        default = "catppuccin-mocha.yaml";
        description = "The theme's file name located in 'pkgs.base16-schemes/share/themes/'.";
        example = "catppuccin-mocha.yaml";
        type = lib.types.str;
      };
      light = lib.mkOption {
        default = "catppuccin-frappe.yaml";
        description = "The theme's file name located in 'pkgs.base16-schemes/share/themes/'.";
        example = "catppuccin-frappe.yaml";
        type = lib.types.str;
      };
    };
    wallpaper = {
      dark = lib.mkOption {
        default = "${inputs.nixos-artwork}/wallpapers/nix-wallpaper-binary-black.png";
        description = "File path to choosen wallpaper.";
        example = "/path/to/file.ext";
        type = lib.types.str;
      };
      light = lib.mkOption {
        default = "${inputs.nixos-artwork}/wallpapers/nix-wallpaper-binary-blue.png";
        description = "File path to choosen wallpaper.";
        example = "/path/to/file.ext";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkMerge [
    {
      stylix.autoEnable = false;
    }

    (lib.mkIf (cfg.enable) {
      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          base16-schemes  # Presets
          home-manager    # Required for switch-mode | 'programs.home-manager.enable' doesn't install
        ;
      } ++ [
        switch-mode       # HM theme switcher script
      ];

      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = lib.mkDefault "${base16}/${theme.dark}";
        image = lib.mkDefault "${wallpaper.dark}";
        polarity = lib.mkDefault "dark";

        cursor = {
          # Variants: Bibata-(Modern/Original)-(Amber/Classic/Ice)
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          # Sizes: 16 20 22 24 28 32 40 48 56 64 72 80 88 96
          size = 24;
        };

        fonts = {
          monospace = lib.mkDefault {
            name = "Iosvmata";
            package = pkgs.iosvmata;
          };

          sizes = lib.mkDefault {
            #applications = 12;
            #desktop = 10;
            #popups = 10;
            terminal = 14;
          };
        };

        opacity = {
          #applications = 1.0;
          #desktop = 1.0;
          #popups = 1.0;
          terminal = 0.9;
        };

        targets = {
          console.enable = true;  # TTY
          gtk.enable = true;
          #qt.enable = true;
        };
      };

      home-manager.users.${myUser} = {
        stylix.targets = {
          # Disabled as browser currently looks strange with Stylix applied
          ${cfgOpts.browser} = {
            enable = false;
            colorTheme.enable = false;
            firefoxGnomeTheme.enable = false;
            profileNames = [ "${myUser}" ];
          };
          bat.enable = true;
          btop.enable = true;
          gnome.enable = true;
          #gnome-text-editor.enable = true;  # Throws assertion about nixpkgs/useGlobalPkgs
          gtk.enable = true;
          #helix.enable = true;
          #hyprland.enable = true;
          #hyprlock.enable = true;
          #hyprpaper.enable = false;
          #kde.enable = true;
          kitty.enable = true;
          #mako.enable = true;
          mangohud.enable = true;
          nixvim = {
            enable = true;
            plugin = "base16-nvim";
            transparentBackground = {
              main = true;
              signColumn = false;
            };
          };
          #qt.enable = true;
          #rofi.enable = true;
          #spicetify.enable = true; # Disabled to troubleshoot
          #tmux.enable = true;
          #waybar.enable = true;
          wezterm.enable = true;
          #wofi.enable = true;
          yazi.enable = true;
          zathura.enable = true;
          #zellij.enable = true;
        };

        specialisation = {
          dark.configuration = {
            stylix = {
              base16Scheme = "${base16}/${theme.dark}";
              image = "${wallpaper.dark}";
              polarity = lib.mkForce "dark";
            };
          };
          light.configuration = {
            stylix = {
              base16Scheme = "${base16}/${theme.light}";
              image = "${wallpaper.light}";
              polarity = lib.mkForce "light";
            };
          };
        };
      };
    })
  ];
}
