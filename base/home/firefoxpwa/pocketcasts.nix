{
  pkgs,
  ...
}:
{
  programs.firefoxpwa.profiles."01KEQNSHKXFQS9Q7C7ZR7PHR68" = {
    name = "Pocket Casts";
    sites."01KEQNSHRSXZS4SB2B3N9PAVWE" = {
      name = "Pocket Casts";
      url = "https://pocketcasts.com/podcasts";
      manifestUrl =
        "file://"
        + (pkgs.writeText "pocketcasts.webmanifest" ''
          {
            "start_url":"https://pocketcasts.com/podcasts",
            "name":"Podcasts - Pocket Casts",
            "description":"Listen to your favorite podcasts online, in your browser. Discover the world's most powerful podcast player.",
            "icons":[
              {
                "src":"https://pocketcasts.com/favicons/favicon.ico",
                "purpose":"any"
              },
              {
                "src":"https://pocketcasts.com/favicons/favicon-16x16.png",
                "type":"image/png",
                "purpose":"any",
                "sizes":"16x16"
              },
              {
                "src":"https://pocketcasts.com/favicons/favicon-32x32.png",
                "type":"image/png",
                "purpose":"any",
                "sizes":"32x32"
              },
              {
                "src":"https://pocketcasts.com/favicons/favicon-144x144.png",
                "type":"image/png",
                "purpose":"any",
                "sizes":"144x144"
              },
              {
                "src":"https://pocketcasts.com/favicons/favicon-256x256.png",
                "type":"image/png",
                "purpose":"any",
                "sizes":"256x256"
              },
              {
                "src":"https://pocketcasts.com/favicons/favicon-512x512.png",
                "type":"image/png",
                "purpose":"any",
                "sizes":"512x512"
              }
            ]
          }
        '');
      desktopEntry = {
        categories = [ "Audio" ];
        icon = pkgs.fetchurl {
          url = "https://static.pocketcasts.com/webplayer/favicons/favicon-512x512.png";
          sha256 = "sha256-N2Tw4m28zEJlL+EzWmiqTS89ArUEtHDnl8+trt3eR1c=";
        };
      };
      settings.config = {
        runtime_enable_wayland = true;
        runtime_use_portals = true;
      };
    };
  };
}
