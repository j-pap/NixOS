final: prev: {
  floorp-unwrapped = (prev.floorp-unwrapped.override {
    privacySupport = true;
    webrtcSupport = true;
    enableOfficialBranding = false;
    geolocationSupport = true;
    # https://github.com/NixOS/nixpkgs/issues/418473
    ltoSupport = false;
  }).overrideAttrs (prev: {
    MOZ_DATA_REPORTING = "";
    MOZ_TELEMETRY_REPORTING = "";
  });

  iosvmata = prev.callPackage ./pkgs/fonts/iosvmata.nix { };

  nix-plugins = prev.nix-plugins.overrideAttrs (old: {
    buildInputs = [
      final.nixVersions.nix_2_28
      #final.nixVersions.latest
      final.boost
    ];
    patches = (old.patches or [ ]) ++ [ ./pkgs/nix-plugins/nix-plugins.patch ];
  });

  pragmasevka = prev.callPackage ./pkgs/fonts/pragmasevka.nix { };
}
