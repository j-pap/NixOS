{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.de.hyprland;
  stylix = config.stylix;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.regreet = {
      enable = false;
      font = {
        name = "Adwaita Sans Regular";
        package = pkgs.adwaita-fonts;
        size = 16;
      };
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme = {
        name = stylix.cursor.name;
        package = stylix.cursor.package;
      };
      iconTheme = {
        name = stylix.icons.dark;
        package = stylix.icons.package;
      };
      settings = {
        #appearance.greeting_msg = "";
        background = {
          path = flk.host.wallpaper.login;
          fit = "Contain"; # Fill | Contain | Cover | ScaleDown
        };
        commands = {
          poweroff = [
            "systemctl"
            "poweroff"
          ];
          reboot = [
            "systemctl"
            "reboot"
          ];
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
        default_session.command =
          if (config.programs.regreet.enable) then
            "${lib.getExe config.programs.regreet.package} --cmd Hyprland"
          else
            "${lib.getExe pkgs.tuigreet} --cmd Hyprland --time --remember --remember-user-session --asterisks --theme 'text=white;time=lightyellow;container=darkgray;border=lightmagenta;prompt=lightgreen;input=white;button=white;action=gray'";
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
