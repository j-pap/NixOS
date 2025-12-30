{
  config,
  pkgs,
  ...
}: {
  programs.wleave = {
    enable = true;
    package = pkgs.wleave;
    settings = {
      buttons-per-row = "3"; # "1/1": single row
      column-spacing = 10;
      row-spacing = 10;
      #margin = 200;
      margin-left = 300;
      margin-right = 300;
      margin-top = 150;
      margin-bottom = 150;
      close-on-lost-focus = false;
      show-keybinds = true;
      #protocol = "layer-shell";
      no-version-info = true;
      delay-command-ms = 100;

      buttons =
        let
          iconPath = "${config.programs.wleave.package}/share/wleave/icons";
        in
        [
          {
            label = "lock";
            action = "hyprlock";
            text = "Lock";
            keybind = "l";
            icon = "${iconPath}/lock.svg";
          }
          {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
            icon = "${iconPath}/suspend.svg";
          }
          {
            label = "hibernate";
            action = "systemctl hybrid-sleep";
            text = "Hibernate";
            keybind = "h";
            icon = "${iconPath}/hibernate.svg";
          }
          {
            label = "logout";
            action = "hyprshutdown --top-label 'Logging out...' --post-cmd 'hyprctl dispatch exit'";
            text = "Logout";
            keybind = "e";
            icon = "${iconPath}/logout.svg";
          }
          {
            label = "reboot";
            action = "hyprshutdown --top-label 'Restarting...' --post-cmd 'systemctl reboot'";
            text = "Reboot";
            keybind = "r";
            icon = "${iconPath}/reboot.svg";
          }
          {
            label = "shutdown";
            action = "hyprshutdown --top-label 'Shutting down...' --post-cmd 'systemctl poweroff'";
            text = "Shutdown";
            keybind = "s";
            icon = "${iconPath}/shutdown.svg";
          }
        ];
    };

    style = ''
      window {
        background-color: rgba(12, 12, 12, 0.8);
      }

      button {
        color: oklab(from var(--view-fg-color) var(--standalone-color-oklab));
        background-color: var(--view-bg-color);
        border: none;
        padding: 10px;
        font-size: 10px;
      }

      button label.action-name {
        font-size: 24px;
      }

      button label.keybind {
        font-size: 20px;
        font-family: monospace;
      }

      button:active {
        color: var(--accent-fg-color);
        background-color: var(--accent-bg-color);
      }

      button:focus,
      button:hover {
        background-color: color-mix(in srgb, var(--accent-bg-color), var(--view-bg-color));
      }

      button:hover label.keybind, button:focus label.keybind {
        opacity: 1;
      }

      /*
      button#lock {
        --view-fg-color: #ffe8b6;
      }

      button#suspend {
        --view-fg-color: #caaff9;
      }

      button#hibernate {
        --view-fg-color: #a8c0ff;
      }

      button#logout {
        --view-fg-color: #ffcca8;
      }

      button#reboot {
        --view-fg-color: #84ffaa;
      }

      button#shutdown {
        --view-fg-color: #ff8d8d;
      }
      */
    '';
  };
}
