final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    kdeFinal: kdePrev: {
      kdeplasma-addons = kdePrev.kdeplasma-addons.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          (final.fetchpatch {
            # https://bugs.kde.org/show_bug.cgi?id=526447
            name = "kdeplasma-addons-fix-apod-url.patch";
            url = "https://bugsfiles.kde.org/attachment.cgi?id=196803";
            hash = "sha256-GaBDd1x6kYsjXnszT4CXUugU9bKn0ZNZrx/RiuUi5O0=";
          })
        ];
      });
    }
  );
}
