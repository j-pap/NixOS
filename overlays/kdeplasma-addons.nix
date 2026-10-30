final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    kdeFinal: kdePrev: {
      kdeplasma-addons = kdePrev.kdeplasma-addons.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          # https://bugs.kde.org/show_bug.cgi?id=526447
          # Fixed in 6.6.8 / 6.7.6 / 6.8.3 / 6.9.0
          (final.fetchpatch {
            name = "kdeplasma-addons-nasa-apod-new-url.patch";
            url = "https://invent.kde.org/plasma/kdeplasma-addons/-/merge_requests/1179.patch";
            hash = "sha256-L97yteyxn8AFwJc1dwcpe8tJt4jHlrl+5tOvOlIf2+4=";
          })
        ];
      });
    }
  );
}
