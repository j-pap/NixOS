{
  config,
  lib,
  pkgs,
  cfgOpts,
  inputs,
  myUser,
  ...
}: let
  cfg = cfgOpts.desktops.cosmic;

  profileImg = ../../assets/profile.png;
  cursor = {
    # Variants: Bibata-(Modern/Original)-(Amber/Classic/Ice)
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    # Sizes: 16 20 22 24 28 32 40 48 56 64 72 80 88 96
    size = 24;
  };
  icon = {
    # Variants: Papirus Papirus-Dark Papirus-Light
    name = "Papirus";
    # Folder color variants: https://github.com/PapirusDevelopmentTeam/papirus-folders
    # adwaita black blue bluegrey breeze brown carmine cyan darkcyan deeporange
    # green grey indigo magenta nordic orange palebrown paleorange pink red
    # teal violet white yaru yellow
    package = pkgs.papirus-icon-theme.override { color = "violet"; };
  };
  wallpaper = {
    day = "${inputs.self}/assets/wallpapers/blobs-l.png";
    night = "${inputs.self}/assets/wallpapers/blobs-d.png";
  };
in {
  options.myOptions.desktops.cosmic.enable = lib.mkEnableOption "Cosmic desktop";

  config = lib.mkIf (cfg.enable) {
    environment = {
      cosmic.excludePackages = [ ];
      systemPackages = [
      # Theming
        #cursor.package      # Cursor theme
        #icon.package        # Icon theme
      ] ++ builtins.attrValues {
        inherit (pkgs)
        # Text
          #neovide           # GUI launcher for neovim
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
      sansSerif = {
        #name = "";
        #package = ;
      };
      serif = config.stylix.fonts.sansSerif;
      sizes = {
        #applications = 10;
        #desktop = 10;
        #popups = 10;
        #terminal = 14;
      };
    };

    home-manager.users.${myUser} = {
      # Sets profile image
      home.file.".face".source = profileImg;

      # Set default application file associations
      xdg.mimeApps = let
        mime = {
          archive = [ "org.gnome.FileRoller.desktop" ];
          audio = [ "com.system76.CosmicPlayer.desktop" ];
          browser = [ "${cfgOpts.browser}.desktop" ];
          #calendar = [ "thunderbird.desktop" ];
          connect = [ "" ];
          #email = [ "thunderbird.desktop" ];
          image = [ "org.gnome.eog.desktop" ];
          pdf = [ "org.gnome.Evince.desktop" ];
          text = [
            "com.system76.CosmicEdit.desktop"
            #"neovide.desktop"
          ];
          video = [ "com.system76.CosmicPlayer.desktop" ];
        };
      in {
        enable = false;
        associations.added = config.xdg.mimeApps.defaultApplications;
        defaultApplications = import ./mimeapps.nix { inherit mime; };
      };
    };
  };
}
