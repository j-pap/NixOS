{
  lib,
  pkgs,
  ...
}:
{
  options.flake.host = {
    isLaptop = lib.mkEnableOption "a laptop" // {
      description = "Whether the host is a laptop.";
    };

    monitor = {
      name = lib.mkOption {
        default = null;
        description = "Name of the Hyprland monitor using `hyprctl monitors all`.";
        example = "eDP-1";
        type = lib.types.nullOr lib.types.str;
      };
      width = lib.mkOption {
        default = null;
        description = "Width of monitor's resolution.";
        example = "1920";
        type = lib.types.nullOr lib.types.str;
      };
      height = lib.mkOption {
        default = null;
        description = "Height of monitor's resolution.";
        example = "1080";
        type = lib.types.nullOr lib.types.str;
      };
      refresh = lib.mkOption {
        default = null;
        description = "Refresh rate of monitor's resolution.";
        example = "60";
        type = lib.types.nullOr lib.types.str;
      };
      scale = lib.mkOption {
        default = "1";
        description = "Scale of monitor's resolution.";
        example = "1.25";
        type = lib.types.str;
      };
    };

    theme = {
      dark = lib.mkOption {
        default = "Catppuccin-Mocha";
        description = "The theme's file name located in 'pkgs.base16-schemes/share/themes/*.yaml'.";
        example = "Catppuccin-Mocha";
        type = lib.types.str;
      };
      light = lib.mkOption {
        default = "Catppuccin-Frappe";
        description = "The theme's file name located in 'pkgs.base16-schemes/share/themes/*.yaml'.";
        example = "Catppuccin-Frappe";
        type = lib.types.str;
      };
    };

    wallpaper = {
      dark = lib.mkOption {
        default = pkgs.nixos-artwork.wallpapers.binary-black.gnomeFilePath;
        description = "File path to choosen wallpaper.";
        example = "/path/to/file.ext";
        type = lib.types.path;
      };
      light = lib.mkOption {
        default = pkgs.nixos-artwork.wallpapers.binary-blue.gnomeFilePath;
        description = "File path to choosen wallpaper.";
        example = "/path/to/file.ext";
        type = lib.types.path;
      };
      login = lib.mkOption {
        default = pkgs.nixos-artwork.wallpapers.nineish-catppuccin-macchiato-alt.gnomeFilePath;
        description = "File path to choosen wallpaper.";
        example = "/path/to/file.ext";
        type = lib.types.path;
      };
    };
  };
}
