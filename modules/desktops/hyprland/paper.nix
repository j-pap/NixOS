{
  osConfig,
  ...
}:
let
  wallpaper = osConfig.flake.host.wallpaper;
in
{
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/
  services.hyprpaper = {
    enable = false;

    settings = {
      splash = false;
      splash_offset = 20.0;
      splash_opacity = 0.8;
      ipc = true;

      preload = [
        wallpaper.dark
      ];

      wallpaper = [
        # "[monitor], path, [fit_mode]" - contain | cover (default) | tile | fill
        ", ${wallpaper.dark}, "
      ];
    };
  };
}
