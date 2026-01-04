{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  hyprland = config.wayland.windowManager.hyprland;
  hypr = hyprland.settings.general;
  runner = hyprland.settings."$runner";
  terminal = hyprland.settings."$terminal";

  trayIcons = config.programs.waybar.settings.mainBar."tray".icon-size;
  iconSize = toString (trayIcons - 3);
  iconWide = toString (trayIcons - 1);
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      wttrbar
      ;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;

    # v0.14.0 - https://github.com/Alexays/Waybar/wiki
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        margin-top = hypr.gaps_in; # 5
        margin-left = hypr.gaps_out - hypr.border_size; # 10 - 2
        margin-bottom = 0;
        margin-right = hypr.gaps_out - hypr.border_size; # 10 - 2
        spacing = 10; # Spacing between modules
        reload_style_on_change = true;

        modules-left = [
          "custom/menu"
          "hyprland/workspaces"
          "mpris"
        ];

        modules-center = [
          "clock"
          "custom/weather"
          #"custom/privacydots"
        ];

        modules-right = [
          "temperature#cpu"
          "temperature#gpu"
          "tray"
        ]
        ++ lib.optional (lib.length (lib.attrsToList hyprland.submaps) > 0) [
          "hyprland/submap"
        ]
        ++ [
          "keyboard-state"
        ]
        ++ lib.optional (osConfig.hardware.bluetooth.enable) [
          "bluetooth"
        ]
        ++ [
          "wireplumber"
          "network"
          "custom/notifications"
          "idle_inhibitor"
          # host batteries (if available)
        ];

        "custom/menu" = {
          format = "";
          on-click = runner;
          on-click-right = "wleave";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          active-only = false;
          hide-active = false;
          all-outputs = true;
          format = "{id}"; # [id] | icon | name | windows
          format-icons = {
            #active = "{id}";
            #default = "{id} {windows}";
            #empty = "";
            #persistent = "{id} {windows}";
            #special = "";
            #urgent = "";
          };
          persistent-workspaces = {
            "*" = 4; # 4 default workspaces per monitor
          };
          sort-by = "id"; # [default] | id | name | number | special-centered
          window-rewrite = {
            #"class<app> title<name>" # Match class & title (class first)
            #"class<app>" # Match class
            #"title<name>" # Match title
            #"<app/name>" # Match any
            "class<(kitty|com.mitchellh.ghostty|com.system76.CosmicTerm|org.gnome.Console|org.kde.konsole|org.wezfurlong.wezterm)>" = "";
            "class<firefox>" = "󰈹";
          };
          window-rewrite-default = "";
          format-window-separator = " ";
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        "mpris" = {
          format = "<span size='${iconSize}pt'>{status_icon}</span> {artist} - {title} ({position}/{length})";
          tooltip-format = "{player_icon} {player}";
          status-icons = {
            playing = "";
            paused = "";
            stopped = "";
          };
          playing-length = 40;
          paused-len = 40;
          stopped-len = 0;
        };

        "clock" = {
          format = "{:%a %d - %H:%M (%Z)}";
          timezones = [
            "America/Chicago"
            "Asia/Tokyo"
            "Europe/Tallinn"
            "Pacific/Auckland"
          ];
          on-click = "thunderbird -calendar";
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              days = "<span>{}</span>";
              today = "<span color='#99ffdd'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "tz_up";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "custom/weather" = {
          exec = "wttrbar --nerd --hide-conditions --fahrenheit --mph --custom-indicator \"{ICON} {temp_F}\"";
          return-type = "json";
          interval = 1800;
          format = "{}°F";
          tooltip = true;
        };

        "custom/privacydots" = {
          exec = lib.getExe (pkgs.callPackage ./privacydots.nix { });
          return-type = "json";
          interval = 3;
          format = "{text}";
          tooltip = true;
          escape = false;
        };

        # hwmon-path in host config
        "temperature#cpu" = {
          interval = 2;
          format = " {temperatureC}°C";
          on-click = "${terminal} btop";
          tooltip = true;
          tooltip-format = "CPU";
        };

        "temperature#gpu" = {
          interval = 2;
          format = "<span size='${iconWide}pt' rise='-3000'>󰢮</span> {temperatureC}°C";
          on-click = lib.mkDefault "${terminal} nvtop";
          tooltip = true;
          tooltip-format = "GPU";
        };

        "tray" = {
          icon-size = 17;
          spacing = 5;
        };

        "hyprland/submap" = {
          format = "{}";
          max-length = 8;
          tooltip = false;
          always-on = false;
        };

        "keyboard-state" = {
          format = {
            numlock = "󰎠 {icon}";
            capslock = "󰪛 {icon}";
            scrolllock = "󰁁 {icon}";
          };
          format-icons = {
            locked = "";
            unlocked = "";
          };
          numlock = false;
          capslock = true;
          scrolllock = false;
        };

        "wireplumber" = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          scroll-step = 5.0;
          #on-click = "";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%-";
          on-scroll-down = "wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+";
          tooltip = true;
          tooltip-format = "Volume: {volume}%\nDevice: {node_name}";
        };

        "bluetooth" = {
          format-disabled = "";
          format-off = "󰂲";
          format-on = "󰂯";
          format-connected = "󰂱";
          format-connected-battery = "󰂱";
          on-click = "blueman-manager";
          tooltip = true;
          tooltip-format-off = "{status}";
          tooltip-format-on = "{status}";
          tooltip-format-connected = "{status} - {device_alias}\t{device_address}";
          tooltip-format-connected-battery = "{status} - {device_alias}\t{device_address}\nBattery: {device_battery_percentage}%";
        };

        "network" = {
          interval = 5;
          family = "ipv4";
          format-ethernet = "󰌘";
          format-wifi = "{icon}";
          format-linked = "";
          format-disconnected = "";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          on-click = "${terminal} nmtui";
          tooltip = true;
          tooltip-format-ethernet = "󰈀 {ifname} ({ipaddr}/{cidr})\n {bandwidthDownBytes}\n {bandwidthUpBytes}";
          tooltip-format-wifi = " {ifname} ({ipaddr}/{cidr})\nSSID: {essid}\n{frequency}GHz - {signalStrength}%\n {bandwidthDownBytes}\n {bandwidthUpBytes}";
          tooltip-format-disconnected = "No network connection";
        };

        "custom/notifications" = {
          tooltip = true;
          format = "{icon}";
          format-icons = {
            notification = "󱅫";
            none = "󰂜";
            dnd-notification = "󰂠";
            dnd-none = "󰪓";
            inhibited-notification = "󰂛";
            inhibited-none = "󰪑";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰪑";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰨚";
            deactivated = "󰨙";
          };
          tooltip = true;
          tooltip-format-activated = "Idle inhibitor {status}";
          tooltip-format-deactivated = "Idle inhibitor {status}";
        };
      };
    };

    style =
      let
        waybarBg = "rgba(255,255,255,0.1)";
        moduleBg = "rgba(0,50,50,0.5)";
        wsActive = "rgba(0,50,50,0.75)";
        wsHover = "rgba(128,128,128,0.5)";
        fontColor = "#FFFFFF";
      in
      ''
        * {
          color: ${fontColor};
          font-family: "NotoSans Nerd Font Propo", sans-serif;
          font-size: 14px;
          margin: 0px;
          padding: 0px;
        }

        window#waybar {
          background-color: ${waybarBg};
          border-radius: 10px;
        }

        .modules-left {
          border-radius: 10px;
          margin-left: 5px;
        }

        .modules-center {
          background-color: ${moduleBg};
          border-radius: 10px;
          padding: 0px 5px;
        }

        .modules-right {
          background-color: ${moduleBg};
          border-radius: 10px;
          padding: 0px 5px;
        }

        #custom-menu {
          border-radius: 100%;
          font-size: 24px;
        }

        #workspaces {
          border: 0 solid ${moduleBg};
          border-radius: 10px;
        }

        #workspaces button {
          background-color: ${moduleBg};
          border-radius: 0px;
          padding: 0px 7px;
        }

        #workspaces button:first-child {
          border-radius: 10px 0px 0px 10px;
        }

        #workspaces button:last-child {
          border-radius: 0px 10px 10px 0px;
        }

        #workspaces button:hover {
          background: none;
          background-color: ${wsHover};
          border-color: transparent;
          box-shadow: none;
          text-shadow: none;
        }

        #workspaces button.active {
          background: transparent;
          /* background-color: ${wsActive}; */
          border: 1px solid ${fontColor};
          font-weight: bold;
        }

        #wireplumber,
        #bluetooth,
        #network,
        #custom-notifications {
          font-size: ${iconSize}pt;
        }

        #idle_inhibitor {
          font-size: ${iconWide}pt;
        }
      '';
  };
}
