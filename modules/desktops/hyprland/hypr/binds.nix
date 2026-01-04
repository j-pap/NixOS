{
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings =
    let
      closeWindowScript = pkgs.writeShellApplication {
        name = "hypr-close-window";
        runtimeInputs = [
          pkgs.jq
          pkgs.xdotool
        ];
        text = ''
          if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
            xdotool getactivewindow windowunmap
          else
            hyprctl dispatch killactive
          fi
        '';
      };
    in
    {
      ####################
      ### KEYBINDINGSS ###
      ####################
      # https://wiki.hypr.land/Configuring/Binds/
      # Use `wev` to determine unknown keys

      "$mod" = "SUPER";

      # MODS, key, description, dispatcher, params
      bindd = [
        ### APPLICATIONS
        "$mod SHIFT, code:61, Password manager, exec, 1password --toggle" # 61=SLASH/QUESTION
        "$mod SHIFT, B, Browser, exec, $browser"
        "$mod SHIFT ALT, B, Browser (Private), exec, $browser --private-window"
        "$mod SHIFT, N, Open editor, exec, $terminal $editor"
        /*
          #"$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          #"$mod, V, exec, cliphist list | rofi --dmenu | cliphist decode | wl-copy"
        */

        ### NAVIGATION
        # Navigate between windows
        "$mod, LEFT, Switch focus to left window, movefocus, l"
        "$mod, H, Switch focus to left window, movefocus, l"
        "$mod, DOWN, Switch focus to bottom window, movefocus, d"
        "$mod, J, Switch focus to bottom window, movefocus, d"
        "$mod, UP, Switch focus to top window, movefocus, u"
        "$mod, K, Switch focus to top window, movefocus, u"
        "$mod, RIGHT, Switch focus to right window, movefocus, r"
        "$mod, L, Switch focus to right window, movefocus, r"

        # Switch between windows
        "ALT, TAB, Switch focus between windows, cyclenext, visible next"
        "ALT SHIFT, TAB, Switch focus between windows in reverse order, cyclenext, visible prev"

        # Navigate between monitors
        "$mod ALT, LEFT, Switch focus to left monitor, focusmonitor, l"
        "$mod ALT, H, Switch focus to left monitor, focusmonitor, l"
        "$mod ALT, DOWN, Switch focus to bottom monitor, focusmonitor, d"
        "$mod ALT, J, Switch focus to bottom monitor, focusmonitor, d"
        "$mod ALT, UP, Switch focus to top monitor, focusmonitor, u"
        "$mod ALT, K, Switch focus to top monitor, focusmonitor, u"
        "$mod ALT, RIGHT, Switch focus to right monitor, focusmonitor, r"
        "$mod ALT, L, Switch focus to right monitor, focusmonitor, r"

        # Navigate between workspaces
        "$mod CTRL, LEFT, Switch to previous workspace, workspace, -1"
        "$mod CTRL, H, Switch to previous workspace, workspace, -1"
        "$mod CTRL, mouse_up, Switch to previous workspace, workspace, -1"
        "$mod CTRL, RIGHT, Switch to next workspace, workspace, +1"
        "$mod CTRL, L, Switch to next workspace, workspace, +1"
        "$mod CTRL, mouse_down, Switch to next workspace, workspace, +1"

        ### MOVE WINDOWS
        # Move window
        "$mod SHIFT, LEFT, Move window left, movewindow, l"
        "$mod SHIFT, H, Move window left, movewindow, l"
        "$mod SHIFT, DOWN, Move window down, movewindow, d"
        "$mod SHIFT, J, Move window down, movewindow, d"
        "$mod SHIFT, UP, Move window up, movewindow, u"
        "$mod SHIFT, K, Move window up, movewindow, u"
        "$mod SHIFT, RIGHT, Move window right, movewindow, r"
        "$mod SHIFT, L, Move window right, movewindow, r"

        # Move current workspace between monitors
        "$mod SHIFT ALT, LEFT, Move workspace to left monitor, movecurrentworkspacetomonitor, l"
        "$mod SHIFT ALT, H, Move workspace to left monitor, movecurrentworkspacetomonitor, l"
        "$mod SHIFT ALT, DOWN, Move workspace to left monitor, movecurrentworkspacetomonitor, d"
        "$mod SHIFT ALT, J, Move workspace to left monitor, movecurrentworkspacetomonitor, d"
        "$mod SHIFT ALT, UP, Move workspace to left monitor, movecurrentworkspacetomonitor, u"
        "$mod SHIFT ALT, K, Move workspace to left monitor, movecurrentworkspacetomonitor, u"
        "$mod SHIFT ALT, RIGHT, Move workspace to right monitor, movecurrentworkspacetomonitor, r"
        "$mod SHIFT ALT, L, Move workspace to right monitor, movecurrentworkspacetomonitor, r"

        # Move window between workspaces
        "$mod SHIFT CTRL, LEFT, Move window to left workspace, movetoworkspace, -1"
        "$mod SHIFT CTRL, H, Move window to left workspace, movetoworkspace, -1"
        "$mod SHIFT CTRL, RIGHT, Move window to right workspace, movetoworkspace, +1"
        "$mod SHIFT CTRL, L, Move window to right workspace, movetoworkspace, +1"

        # Scratchpad workspace
        "$mod, S, Toggle scratchpad, togglespecialworkspace, scratchpad"
        "$mod SHIFT, S, Move window to scratchpad, movetoworkspacesilent, special:scratchpad"
      ]
      ++ (
        # Nix-fied workspace management
        builtins.concatLists (
          builtins.genList (
            i:
            let
              key = toString i;
              ws = toString (i + 1);
            in
            [
              # Switch to workspace
              "$mod, code:1${key}, Switch to workspace ${ws}, workspace, ${ws}"
              # Move window to workspace
              "$mod SHIFT, code:1${key}, Move window to workspace ${ws}, movetoworkspace, ${ws}"
            ]
          ) 10
        )
      )
      ++ [
        ### MANAGE WINDOWS
        "$mod, Q, Close active window, exec, ${lib.getExe closeWindowScript}"
        "$mod, M, Toggle maximized window width, fullscreen, 1"
        "$mod, F11, Toggle fullscreen window, fullscreen, 0"

        # Resize window
        "$mod, code:20, Resize window's left side, resizeactive, -50 0"
        "$mod, code:21, Resize window's right side, resizeactive, 50 0"
        "$mod SHIFT, code:20, Resize window's top side, resizeactive, 0 -50"
        "$mod SHIFT, code:21, Resize window's bottom side, resizeactive, 0 50"

        ### MANAGE TILED WINDOWS
        "$mod, Y, Toggle floating/tiling window, togglefloating, "
        "$mod, P, Toggle pseudo window, pseudo, "
        "$mod, O, Toggle window orientation, togglesplit, "

        ### OTHER SYSTEM SHORTCUTS
        "$mod SHIFT, F, Open file manager, exec, $files"
        "$mod, RETURN, Open terminal, exec, $terminal"
        "$mod, ESCAPE, Lock screen, exec, hyprlock"
        "$mod SHIFT, ESCAPE, Log out, exec, hyprshutdown --top-label 'Logging out...' --post-cmd 'hyprctl dispatch exit'"

        # Screenshots
        ", PRINT, Screenshot entire screen, exec, $screenshot --mode active --mode output"
        "SHIFT, PRINT, Screenshot a region, exec, $screenshot --mode region"
        "ALT, PRINT, Screenshot active window, exec, $screenshot --mode active --mode window"
        "$mod, PRINT, Color picker, exec, pkill hyprpicker || hyprpicker --autocopy"

        "CTRL ALT, DELETE, Session controls, exec, wleave"
        "$mod, D, Show desktop, exec, ${lib.getExe (pkgs.callPackage ./showdesktop.nix { })}"
      ];

      # On-release
      binddr = [
        "$mod, Super_L, Application runner, exec, $runner"
        #"CAPS, Caps_Lock, , exec, notify-send \"Keyboard\" \"$(awk '{print \"Caps lock \"($0?\"on\":\"off\"); exit}' /sys/class/leds/input*\:\:capslock/brightness)\""
      ];

      # Mouse
      binddm = [
        # Move/resize windows w/ $mod + LMB/RMB and dragging
        "$mod, mouse:272, Move window, movewindow"
        "$mod, mouse:273, Resize window, resizewindow"
        "$mod ALT, mouse:272, Resize window, resizewindow"
      ];

      # Locked
      binddl = [
        # Audio mutes
        ", XF86AudioMute, Toggle speaker mute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, Toggle mic mute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        # Media controls
        ", XF86AudioPrev, Rewind -15s, exec, playerctl position 15-"
        ", XF86AudioPlay, Play/pause, exec, playerctl play-pause"
        ", XF86AudioPause, Play/pause, exec, playerctl play-pause"
        ", XF86AudioNext, Skip +15s, exec, playerctl position 15+"
      ];

      # Locked / Held
      binddlo = [
        # Media controls
        ", XF86AudioPrev, Previous track, exec, playerctl previous"
        ", XF86AudioNext, Next track, exec, playerctl next"
      ];

      # Locked / Repeated
      binddle = [
        # Audio volume
        ", XF86AudioLowerVolume, Decrease volume by 5%, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, Increase volume by 5%, exec, wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+"
        # Monitor brightness
        ", XF86MonBrightnessDown, Decrease screen brightness, exec, brightnessctl set 10%-"
        ", XF86MonBrightnessUp, Increase screen brightness, exec, brightnessctl set 10%+"
      ];

      submaps = {
        #<name>.settings.bindd = [ ];
      };
    };
}
