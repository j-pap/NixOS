{
  config,
  lib,
  pkgs,
  ffVariant,
  flk,
  ...
}:
let
  cfg = config.flake.stylix;

  base16 = "${pkgs.base16-schemes}/share/themes";
  switch-mode = pkgs.callPackage ./switch-mode.nix { };
in
{
  options.flake.stylix.enable = lib.mkEnableOption "Stylix";

  config = lib.mkMerge [
    {
      stylix = {
        autoEnable = false;

        cursor = lib.mkDefault {
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
          sansSerif = lib.mkDefault {
            name = "Noto Sans";
            package = pkgs.noto-fonts;
          };
          serif = config.stylix.fonts.sansSerif;
          sizes = lib.mkDefault {
            #applications = 12;
            #desktop = 10;
            #popups = 10;
            terminal = 14;
          };
        };
        icons = lib.mkDefault {
          #enable = true;
          # Color variant overrides: https://github.com/PapirusDevelopmentTeam/papirus-folders
          # adwaita black blue bluegrey breeze brown carmine cyan darkcyan deeporange
          # green grey indigo magenta nordic orange palebrown paleorange pink red
          # teal violet white yaru yellow
          #package = pkgs.papirus-icon-theme.override { color = "violet"; };
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
      };
    }

    (lib.mkIf (cfg.enable) {
      environment.systemPackages =
        builtins.attrValues {
          inherit (pkgs)
            base16-schemes # Theme presets
            home-manager   # Required for switch-mode | 'programs.home-manager.enable' doesn't install
            ;
        }
        ++ [
          switch-mode # HM theme switcher script
        ];

      stylix = {
        enable = true;
        base16Scheme = lib.mkDefault "${base16}/${lib.toLower flk.host.theme.dark}.yaml";
        image = lib.mkDefault "${flk.host.wallpaper.dark}";
        polarity = lib.mkDefault "dark";

        opacity = lib.mkDefault {
          #applications = 1.0;
          #desktop = 1.0;
          #popups = 1.0;
          terminal = 0.9;
        };

        targets = {
          console.enable = true; # TTY
          gtk.enable = true;
          #qt.enable = true;
          regreet.enable = lib.mkIf (config.programs.regreet.enable) true;
        };
      };

      home-manager.users.${flk.user} = {
        stylix.targets = {
          ${ffVariant} = {
            enable = false; # Disabled as browser currently looks strange with Stylix applied
            colorTheme.enable = false;
            firefoxGnomeTheme.enable = false;
            profileNames = [ flk.user ];
          };
          bat.enable = true;
          btop.enable = true;
          gnome.enable = true;
          #gnome-text-editor.enable = true; # Throws assertion about nixpkgs/useGlobalPkgs
          gtk.enable = true;
          #helix.enable = true;
          #hyprland.enable = true;
          #hyprlock.enable = true;
          #hyprpaper.enable = false;
          #kde.enable = true;
          kitty.enable = true;
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
              base16Scheme = "${base16}/${lib.toLower flk.host.theme.dark}.yaml";
              image = "${flk.host.wallpaper.dark}";
              polarity = lib.mkForce "dark";
            };
          };
          light.configuration = {
            stylix = {
              base16Scheme = "${base16}/${lib.toLower flk.host.theme.light}.yaml";
              image = "${flk.host.wallpaper.light}";
              polarity = lib.mkForce "light";
            };
          };
        };
      };
    })
  ];
}
