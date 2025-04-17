{
  lib,
  pkgs,
  cfgOpts,
  inputs,
  ...
}: let
  cfg = cfgOpts.flatpak;
  # Search packages via 'https://flathub.org/apps/search'
  flatPaks = [
    #"org.libreoffice.LibreOffice"
  ] ++ lib.optional (cfgOpts.desktops.gnome.enable) [
    "com.github.tchx84.Flatseal"
  ];
in {
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  options.myOptions.flatpak.enable = lib.mkEnableOption "Flatpak";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = (lib.optional (cfgOpts.desktops.gnome.enable) [
      pkgs.gnome-software             # Gnome store
    ]) ++ (lib.optional (cfgOpts.desktops.kde.enable) [
      pkgs.kdePackages.discover       # KDE store
      pkgs.kdePackages.flatpak-kcm    # Flatpak KDE settings module
    ]);

    services.flatpak = {
      enable = true;
      packages = flatPaks;
      remotes = lib.singleton {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
      uninstallUnmanaged = false;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
