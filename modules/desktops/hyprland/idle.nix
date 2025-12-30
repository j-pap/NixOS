{
  # https://wiki.hypr.land/Hypr-Ecosystem/hypridle/
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock --grace 3";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        inhibit_sleep = 3;
      };

      listener = [
        # 3min - dim screen / screensaver
        {
          timeout = 180;
          on-timeout = "brightnessctl --save set 10%";
          on-resume = "brightnessctl --restore";
        }
        # 5min - lock
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # 5.5min - turn off screen
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl --restore";
        }
        # 5.5min - turn off keyboard backlight
        {
          timeout = 330;
          on-timeout = "brightnessctl --device='*kbd_backlight' --save set 0";
          on-resume = "brightnessctl --device='*kbd_backlight' --restore";
        }
        /*
        # 10min - suspend
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
        */
      ];
    };
  };
}
