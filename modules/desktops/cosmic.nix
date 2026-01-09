{
  config,
  lib,
  pkgs,
  browser,
  flk,
  myUser,
  ...
}:
let
  cfg = config.flake.de.cosmic;
  stylix = config.stylix;
  wallpaper = flk.host.wallpaper;
  profileImg = ../../assets/profile.png;
in
{
  options.flake.de.cosmic.enable = lib.mkEnableOption "COSMIC DE";

  config = lib.mkIf (cfg.enable) {
    flake.terminal = lib.mkDefault "cosmic-term";

    environment = {
      cosmic.excludePackages = [ ];
      systemPackages = [
        #stylix.cursor.package
        #stylix.icons.package
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          # Extensions
          cosmic-ext-applet-caffeine # Caffeine
          cosmic-ext-applet-minimon  # Hardware usage
          cosmic-ext-tweaks          # DE tweak tool
          ;
      };
    };

    programs.seahorse.enable = true;
    security.pam.services = {
      cosmic-greeter.enableGnomeKeyring = true;
      login.enableGnomeKeyring = lib.mkForce false; # Override GDM's setting from services.gnome.gnome-keyring
    };
    services.gnome.gnome-keyring.enable = true;

    services = {
      desktopManager.cosmic = {
        enable = true;
        showExcludedPkgsWarning = true;
        xwayland.enable = true;
      };
      displayManager.cosmic-greeter.enable = true;
    };

    stylix.fonts = {
      monospace = {
        name = "Noto Sans Mono";
        package = pkgs.noto-fonts;
      };
      sansSerif = {
        name = "Open Sans";
        package = pkgs.open-sans;
      };
      /*
      sizes = {
        #applications = 10;
        #desktop = 10;
        #popups = 10;
        #terminal = 14;
      };
      */
    };

    systemd.packages = lib.optional (config.services.flatpak.enable) [
      pkgs.cosmic-store # Flatpak store
    ];

    home-manager.users.${myUser} = {
      home.file.".face".source = profileImg; # Sets profile image

      # Set default application file associations
      xdg.mimeApps =
        let
          mime = {
            archive = [ "org.gnome.FileRoller.desktop" ];
            audio = [ "com.system76.CosmicPlayer.desktop" ];
            browser = [ "${browser}.desktop" ];
            #calendar = [ "thunderbird.desktop" ];
            connect = [ "" ];
            email = [ "thunderbird.desktop" ];
            image = [ "org.gnome.eog.desktop" ];
            pdf = [ "org.gnome.Evince.desktop" ];
            text = [ "com.system76.CosmicEdit.desktop" ];
            video = [ "com.system76.CosmicPlayer.desktop" ];
          };
        in
        {
          enable = false;
          associations.added = config.xdg.mimeApps.defaultApplications;
          defaultApplications = import ./mimeapps.nix { inherit mime; };
        };
    };
  };
}
