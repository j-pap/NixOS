{
  config,
  flk,
}:
{
  # Settings -> Appearance
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Style
      #color-scheme = "prefer-dark"; # default or prefer-dark

      # Accent Color
      accent-color = "purple"; # blue teal green yellow orange red pink purple slate
    };
    "org/gnome/desktop/background" = {
      # Background
      #picture-options = "zoom";
      #picture-uri = "file://${flk.host.wallpaper.light}";
      #picture-uri-dark = "file://${flk.host.wallpaper.dark}";
    };
  };

  # Host-specific dynamic wallpaper
  xdg.dataFile =
    let
      host = config.networking.hostName;
      wall = flk.host.wallpaper;
    in
    {
      "backgrounds/${host}/${host}-d.png".source = wall.dark;
      "backgrounds/${host}/${host}-l.png".source = wall.light;
      "gnome-background-properties/${host}.xml".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
        <wallpapers>
          <wallpaper deleted="false">
            <name>${host}</name>
            <filename>/home/${flk.user}/.local/share/backgrounds/${host}/${host}-l.png</filename>
            <filename-dark>/home/${flk.user}/.local/share/backgrounds/${host}/${host}-d.png</filename-dark>
            <options>zoom</options>
            <shade_type>solid</shade_type>
            <pcolor>#ffffff</pcolor>
            <scolor>#000000</scolor>
          </wallpaper>
        </wallpapers>
      '';
    };
}
