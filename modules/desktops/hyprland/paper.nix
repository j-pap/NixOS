{
  inputs,
  osConfig,
  ...
}: let
  cfgHosts = osConfig.myHosts;
  wallpaper = {
    dir = "${inputs.self}/assets/wallpapers";
    day = "${wallpaper.dir}/blobs-l.png";
    night = "${wallpaper.dir}/blobs-d.png";
  };
in {
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/
  services.hyprpaper = {
    enable = false;

    settings = {
      splash = false;
      splash_offset = 20.0;
      splash_opacity = 0.8;
      ipc = true;

      preload = [
        wallpaper.night
      ];

      wallpaper = [
        # "[monitor], path, [fit_mode]" - contain | cover (default) | tile | fill
        ", ${wallpaper.night}, "
      ];
    };
  };
}
