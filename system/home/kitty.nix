{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  flk = osConfig.flake;
  user = osConfig.flake.user;
in
{
  home.packages = [ pkgs.kitty-themes ];
  programs = {
    bash.shellAliases = {
      "s" = "kitten ssh \"$@\"";
    };

    kitty = {
      enable = true;
      extraConfig = lib.mkIf (!osConfig.stylix.enable) ''
        include /home/${user}/.config/kitty/current-theme.conf
      '';
      font.name = lib.mkDefault "Iosvmata";
      font.size = lib.mkDefault 14;
      keybindings = {
        "ctrl+shift+enter" = "launch --cwd=current";
        "f2" = "new_os_window_with_cwd";
      };
      settings = {
        #background_blur = lib.mkIf (flk.de.kde.enable) 1; # Only KDE supported, but even minimum (1) is too aggressive
        background_opacity = lib.mkDefault "0.9";
        confirm_os_window_close = 0;
        copy_on_select = "clipboard";
        dim_opacity = "0.5"; # Dim/faint font's opacity
        dynamic_background_opacity = "yes";
        enable_audio_bell = "no";
        focus_follows_mouse = "yes";
        linux_display_server = "wayland";
        symbol_map = "U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+ed00-U+efc1,U+f000-U+f2ff,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f533,U+f0001-U+f1af0 Symbols Nerd Font Mono";
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
        touch_scroll_multiplier = "2.0";
        wayland_titlebar_color = "system";
      };
    };
  };
}
