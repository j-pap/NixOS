{
  lib,
  pkgs,
  cosmicLib,
  flk,
  ...
}:
let
  inherit (cosmicLib.cosmic) mkRON;

  themeToggle = pkgs.writeShellScriptBin "cosmic-theme-toggle" ''
    theme="/home/${flk.user}/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark"
    is_dark="$(cat "$theme")"
    if [[ $is_dark == "true" ]]; then
      echo "false" > "$theme"
      # Kitty
      ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.dark}.conf /home/${flk.user}/.config/kitty/current-theme.conf
      kill -SIGUSR1 $(pidof kitty) 2>/dev/null
    else
      echo "true" > "$theme"
      # Kitty
      ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.light}.conf /home/${flk.user}/.config/kitty/current-theme.conf
      kill -SIGUSR1 $(pidof kitty) 2>/dev/null
    fi
  '';
in
[
  {
    action = mkRON "enum" "Disable";
    key = "Super+t";
  }
  {
    action = mkRON "enum" {
      variant = "System";
      value = [ (mkRON "enum" "Terminal") ];
    };
    key = "Super+Return";
  }
  {
    action = mkRON "enum" {
      variant = "System";
      value = [ (mkRON "enum" "AppLibrary") ];
    };
    key = "Super";
  }
  {
    action = mkRON "enum" {
      variant = "System";
      value = [ (mkRON "enum" "Launcher") ];
    };
    key = "Super+space";
  }
  {
    description = mkRON "optional" "Open a private web browser";
    action = mkRON "enum" {
      variant = "Spawn";
      value = [ "${flk.browser} --private-window" ];
    };
    key = "Super+Alt+b";
  }
  {
    description = mkRON "optional" "Toggle Theme";
    action = mkRON "enum" {
      variant = "Spawn";
      value = [ "${lib.getExe themeToggle}" ];
    };
    key = "Super+Shift+t";
  }
  {
    description = mkRON "optional" "Open 1Password";
    action = mkRON "enum" {
      variant = "Spawn";
      value = [ "1password --toggle" ];
    };
    key = "Super+Shift+slash";
  }
]
