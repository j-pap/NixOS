{
  lib,
  pkgs,
  flk,
  stylix,
}:
let
  gnomeExts =
    builtins.attrValues {
      inherit (pkgs.gnomeExtensions)
        alphabetical-app-grid
        appindicator
        bluetooth-quick-connect
        blur-my-shell
        caffeine
        clipboard-indicator
        dash-to-dock
        forge
        fuzzy-app-search
        hibernate-status-button
        #hot-edge
        just-perfection
        lock-keys
        night-theme-switcher
        notification-timeout
        power-profile-switcher
        search-light
        vitals
        weather-or-not
        ;
    }
    ++ lib.optionals (flk.host.isLaptop) [
      pkgs.gnomeExtensions.battery-health-charging
    ];
in
{
  imports = [ ./forge.nix ];

  home.packages = gnomeExts;

  dconf.settings = {
    "org/gnome/shell" = {
      #disable-user-extensions = false;
      enabled-extensions = (map (extension: extension.extensionUuid) gnomeExts) ++ [
        # Enable extensions that ship, but aren't enabled by default
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    # AppIndicator
    "org/gnome/shell/extensions/appindicator".icon-size = 16;

    # Battery Health Charging
    "org/gnome/shell/extensions/Battery-Health-Charging" =
      let
        bal = 85;
        ful = 90;
      in
      lib.optionalAttrs (flk.host.isLaptop) {
        charging-mode = "ful";
        bal-end-threshold = bal;
        ful-end-threshold = ful;
        current-bal-end-threshold = bal;
        current-ful-end-threshold = ful;
        amend-power-indicator = true;
        indicator-position = 4;
        show-system-indicator = false;
      };

    # Bluetooth Quick Connect
    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      bluetooth-auto-power-off = true;
      bluetooth-auto-power-off-interval = 180;
      refresh-button-on = true;
      show-battery-icon-on = true;
      show-battery-value-on = true;
    };

    # Blur my Shell
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      static-blur = true;
      override-background = true;
      style-panel = 0; # 0: transparent, 1: light, 2: dark, 3: contrasted
      unblur-in-overview = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      sigma = 8;
      opacity = 230; # 90%
      dynamic-opacity = false;
      blur-on-overview = true;
      whitelist = [
        "com.mitchellh.ghostty"
        "com.system76.CosmicTerm"
        "kitty"
        "org.gnome.Console"
        "org.kde.konsole"
        "org.wezfurlong.wezterm"
      ];
    };

    # Clipboard Indicator
    "org/gnome/shell/extensions/clipboard-indicator" = {
      clear-on-boot = true;
      strip-text = true;
      topbar-preview-size = 10;
    };

    # Dash to Dock
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      custom-theme-shrink = true;
      disable-overview-on-startup = true;
      hot-keys = false;
      intellihide-mode = "ALL_WINDOWS";
      scroll-action = "switch-workspace";
      show-trash = false;
    };

    # Hibernate Status Button
    "org/gnome/shell/extensions/hibernate-status-button" = {
      show-hybrid-sleep = false;
      show-suspend-then-hibernate = false;
    };

    # Just Perfection
    "org/gnome/shell/extensions/just-perfection" = {
      notification-banner-position = 1; # 1=top center
      panel-button-padding-size = 3; # 3=2px
      panel-indicator-padding-size = 0; # 0=shell theme
      startup-status = 0; # 0=desktop, 1=overview
    };

    # Lock Keys
    "org/gnome/shell/extensions/lockkeys".style = "show-hide-capslock";

    # Night Theme Switcher
    "org/gnome/shell/extensions/nightthemeswitcher/commands" =
      let
        switch-mode = pkgs.callPackage ../programs/stylix/switch-mode.nix { };
        themeSwitch = pkgs.writeShellScriptBin "gnome-theme-switch" ''
          CURRENT_THEME=$(gsettings get org.gnome.desktop.interface color-scheme | cut -d "'" -f 2)
          if [[ "$CURRENT_THEME" = "default" ]]; then
            # Kitty
            ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.light}.conf /home/${flk.user}/.config/kitty/current-theme.conf
            kill -SIGUSR1 $(pidof kitty) 2>/dev/null
            # Wallpaper
            #gsettings set org.gnome.desktop.background picture-uri '${flk.host.wallpaper.light}'
          elif [[ "$CURRENT_THEME" = "prefer-dark" ]]; then
            # Kitty
            ln -fs ${pkgs.kitty-themes}/share/kitty-themes/themes/${flk.host.theme.dark}.conf /home/${flk.user}/.config/kitty/current-theme.conf
            kill -SIGUSR1 $(pidof kitty) 2>/dev/null
            # Wallpaper
            #gsettings set org.gnome.desktop.background picture-uri-dark '${flk.host.wallpaper.dark}'
          fi;
        '';
      in
      {
        enabled = true;
        sunrise = if (stylix.enable) then "${lib.getExe switch-mode} light" else "${lib.getExe themeSwitch}";
        sunset = if (stylix.enable) then "${lib.getExe switch-mode} dark" else "${lib.getExe themeSwitch}";
      };
    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      manual-schedule = false;
      nightthemeswitcher-ondemand-keybinding = [ "<Shift><Super>t" ];
      sunrise = 7;
      sunset = 17;
    };

    # Notification Timeout
    "org/gnome/shell/extensions/notification-timeout" = {
      always-normal = true;
      ignore-idle = true;
      timeout = 5000;
    };

    # Power Profile Switcher
    "org/gnome/shell/extensions/power-profile-switcher" = lib.mkDefault {
      # performance, balanced, power-saver
      ac = "performance";
      bat = "power-saver";
    };

    # Search Light
    "org/gnome/shell/extensions/search-light".shortcut-search = [ "<Super>space" ];

    # Vitals
    "org/gnome/shell/extensions/vitals" = {
      alphabetize = false;
      fixed-widths = false;
      hide-icons = false;
      hide-zeros = false;
      menu-centered = true;
      position-in-panel = 2;
      update-time = 2; # 5 seconds default
      use-higher-precision = false;
    };

    # Weather or Not
    "org/gnome/shell/extensions/weatherornot".position = "clock-left";
  };
}
