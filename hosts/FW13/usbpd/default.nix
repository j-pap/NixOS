{
  lib,
  stdenv,
  linuxPackages_latest,
  kernel ? linuxPackages_latest.kernel,
}:
stdenv.mkDerivation {
  pname = "fw-usbpd-charger";
  inherit (kernel)
    version
    src
    nativeBuildInputs
    postPatch
    ;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  modulePath = "drivers/power/supply";

  patches = [ ./usbpd_charger.patch ];

  buildPhase = ''
    runHook preBuild

    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install

    runHook postInstall
  '';

  meta = {
    description = "Framework cros_usbpd_charger kernel module";
    license = lib.licenses.gpl3;
  };
}
