{
  config,
  lib,
  pkgs,
  cfgOpts,
  inputs,
  ...
}:
let
  cfg = cfgOpts.desktops.hyprland;
  wallpaper = {
    dir = "${inputs.self}/assets/wallpapers";
    regreet = "${wallpaper.dir}/blobs-l.png";
  };
in {
  config = lib.mkIf (cfg.enable) {
    programs.regreet = {
      enable = false;
      font = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
        size = 16;
      };
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme = {
        name = cfg.cursor.name;
        package = cfg.cursor.package;
      };
      iconTheme = {
        name = cfg.icons.name;
        package = cfg.icons.package;
      };
      settings = {
        #appearance.greeting_msg = "";
        background = {
          path = wallpaper.regreet;
          fit = "Contain"; # Fill | Contain | Cover | ScaleDown
        };
        commands = {
          poweroff = [ "systemctl" "poweroff" ];
          reboot = [ "systemctl" "reboot" ];
        };
        #env = { };
        GTK = {
          application_prefer_dark_theme = true;
          cursor_blink = true;
        };
        widget.clock = {
          format = "%H:%M";
          resolution = "500ms";
          label_width = 150;
        };
      };
    };

    services.greetd = {
      enable = true;
      useTextGreeter = lib.mkIf (!config.programs.regreet.enable) true;
      settings = {
        default_session.command = (
          if (config.programs.regreet.enable) then
            "${lib.getExe config.programs.regreet.package} --cmd Hyprland"
          else
            "${lib.getExe pkgs.tuigreet} --cmd Hyprland --time --remember --remember-user-session --asterisks --theme 'text=white;time=lightyellow;container=darkgray;border=lightmagenta;prompt=lightgreen;input=white;button=white;action=gray'"
        );
        /*
        # Auto login
        initial_session = {
          command = config.services.greetd.settings.default_session.command;
          user = myUser;
        };
        */
        terminal.vt = 1;
      };
    };
  };
}
