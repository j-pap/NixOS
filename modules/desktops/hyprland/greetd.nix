{
  config,
  lib,
  pkgs,
  cfgOpts,
  inputs,
  myUser,
  ...
}:
let
  cfg = cfgOpts.desktops.hyprland;
  cursor = {
    name = cfg.cursor.name;
    package = cfg.cursor.package;
    size = cfg.cursor.size;
  };
  icon = {
    name = cfg.icon.name;
    package = cfg.icon.package;
  };
  wallpaper = {
    dir = "${inputs.self}/assets/wallpapers";
    regreet = "${wallpaper.dir}/blobs-l.png";
  };
in {
  config = lib.mkIf (cfg.enable) {
    programs.regreet = {
      enable = false;
      settings = ''
        [background]
        path = "${wallpaper.regreet}"
        # Available values: "Fill", "Contain", "Cover", "ScaleDown"
        fit = "Contain"

        [commands]
        reboot = [ "systemctl", "reboot" ]
        poweroff = [ "systemctl", "poweroff" ]

        [env]
        #ENV_VARIABLE = "value"

        [GTK]
        application_prefer_dark_theme = true
        cursor_theme_name = "${cursor.name}"
        font_name = "Cantarell 16"
        icon_theme_name = "${icon.name}"
        #theme_name = ""
      '';
    };

    services.greetd = {
      enable = true;
      useTextGreeter = lib.mkIf (!config.programs.regreet.enable) true;

      package = (
        if (config.programs.regreet.enable) then
          pkgs.regreet
        else
          pkgs.tuigreet
      );

      settings = let
        hyprApps = cfg.hyprApps;
      in {
        default_session = {
          command = (
            if (config.programs.regreet.enable) then
              # Regreet
              "${hyprApps.hyprland}"
            else
              # Tuigreet
              "${hyprApps.tuigreet} --asterisks --remember --remember-user-session --time --cmd ${hyprApps.hyprland}"
          );
          user = myUser;
        };

        # Auto login
        #initial_session = config.services.greetd.settings.default_session;
      };
    };
  };
}
