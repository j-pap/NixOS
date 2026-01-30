{
  config,
  flk,
}:
let
  host = config.networking.hostName;
  width = flk.host.monitor.width;
  height = flk.host.monitor.height;
  wall = flk.host.wallpaper;
in
{
  # System Settings -> Wallpaper
  programs.plasma = {
    workspace = {
      # Wallpaper type -> Image
      #wallpaper = "/home/${flk.user}/.local/share/wallpapers/${host}/";

      # Wallpaper type -> Picture of the Day
      /*
        wallpaperPictureOfTheDay = {
          provider = "bing"; # null, “apod”, “bing”, “flickr”, “natgeo”, “noaa”, “wcpotd”, “epod”, “simonstalenhag”
          #updateOverMeteredConnection = false;
        };
      */

      # Positioning
      #wallpaperFillMode = "preserveAspectCrop"; # preserveAspectCrop, stretch, preserveAspectFit, pad, tile

      # Positioning -> Background
      /*
        wallpaperBackground = {
          # How empty space is handled with "pad" fill (centered)
          #blur = false;
          #color = "255,255,255";
        };
      */
    };
  };

  # Host-specific dynamic wallpaper
  xdg.dataFile = {
    "wallpapers/${host}/contents/images/${width}x${height}.png".source = wall.light;
    "wallpapers/${host}/contents/images_dark/${width}x${height}.png".source = wall.dark;
    "wallpapers/${host}/metadata.json".text = ''
      {
          "KPlugin": {
              "Id": "${host}",
              "Name": "Flake"
          }
      }
    '';
  };
}
