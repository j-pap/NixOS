{
  lib,
  osConfig,
  ...
}:
let
  monitor = osConfig.flake.host.monitor;
  width = toString (builtins.ceil ((lib.toInt monitor.width) * .3));
  height = toString (builtins.ceil ((lib.toInt monitor.height) * .3));
in
{
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprlauncher/
  services.hyprlauncher = {
    enable = true;

    settings = {
      general.grab_focus = true;
      cache.enabled = true;
      ui.window_size = "${width} ${height}";

      finders = {
        default_finder = "desktop";
        desktop_prefix = "";
        unicode_prefix = ".";
        math_prefix = "=";
        font_prefix = "'";
        desktop_launch_prefix = "";
        desktop_icons = true;
      };
    };
  };
}
