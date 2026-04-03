{
  lib,
  stdenv,
  writers,
  makeWrapper,
  gobject-introspection,
  gusb,
  json-glib,
  libfprint,
  libfprint-2-tod1-goodix,
  python3,
  python3Packages,
}:
let
  pythonBin = writers.writePython3Bin "fprint-clear-storage" {
    flakeIgnore = [ "E402" "E703" ];
    libraries = [ python3Packages.pygobject3 ];
  } ''
    import gi
    gi.require_version('FPrint', '2.0')
    from gi.repository import FPrint

    ctx = FPrint.Context()

    print("Looking for fingerprint devices.")

    devices = ctx.get_devices()

    for dev in devices:
        print(dev)
        print(dev.get_driver())
        print(dev.props.device_id);

        dev.open_sync()

        dev.clear_storage_sync()
        print("All prints deleted.")

        dev.close_sync()

    if devices:
        print("All prints on all devices deleted.")
    else:
        print("No devices found.")
  '';
in
stdenv.mkDerivation {
  pname = "fprint-clear-storage";
  version = "1.0.0";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    gobject-introspection
    gusb
    json-glib
    libfprint
    libfprint-2-tod1-goodix
    python3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${pythonBin}/bin/fprint-clear-storage $out/bin/fprint-clear-storage \
      --set GI_TYPELIB_PATH "${gobject-introspection.out}/lib/girepository-1.0:${libfprint.out}/lib/girepository-1.0:${gusb.out}/lib/girepository-1.0:${json-glib.out}/lib/girepository-1.0"

    runHook postInstall
  '';

  meta = {
    description = "Python utility to clear fingerprint storage";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
