{
  lib,
  osConfig,
  ...
}:
{
  # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      auth.fingerprint.enabled = lib.mkIf (osConfig.services.fprintd.enable) true;

      animations = {
        enabled = true;

        bezier = [
          "linear, 1, 1, 0, 0"
        ];

        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#background
      background = lib.singleton {
        monitor = "";
        path = "screenshot"; # path, screenshot or empty for color
        color = "rgba(17, 17, 17, 1.0)"; # Fallback or set via path
        blur_passes = 3;
      };

      # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#image
      image = lib.singleton {
        monitor = "";
        path = "$HOME/.face";
        size = 150;
        rounding = -1;
        border_size = 4;
        border_color = "rgba(221, 221, 221, 1.0)";
        position = "0, -75";
        halign = "center";
        valign = "center";
        shadow_passes = 1;
      };

      # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#shape

      # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#input-field
      input-field = lib.singleton {
        monitor = "";
        size = "20%, 55";
        outline_thickness = 4;

        dots_size = 0.25;
        dots_spacing = 0.15;
        dots_center = true;
        dots_rounding = -1;
        dots_text_format = "";

        outer_color = "rgba(17, 17, 17, 1.0)";
        inner_color = "rgba(200, 200, 200, 1.0)";
        font_color = "rgba(10, 10, 10, 1.0)";
        font_family = "Noto Sans";

        fade_on_empty = false;
        fade_timeout = 2000;
        placeholder_text = "<i>password...</i>";
        hide_input = false;
        hide_input_base_color = "rgba(153, 170, 187)";
        rounding = -1;

        check_color = "rgba(204, 136, 34, 1.0)";
        fail_color = "rgba(204, 34, 34, 1.0)";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "rgba(204, 102, 255, 1.0)";
        numlock_color = "";
        bothlock_color = "";
        invert_number = false;
        swap_font_color = false;

        position = "0, -280";
        halign = "center";
        valign = "center";
        shadow_passes = 1;
      };

      # https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#label
      label = [
        {
          monitor = "";
          text = "cmd[update:60000] echo -e \"<span size='80pt'>\"$TIME\"</span>\\n\"$(date +'%A, %b %d, %Y')";
          text_align = "center";
          color = "rgba(254, 254, 254, 1.0)";
          font_size = 18;
          font_family = "Sans";
          position = "0, -15%";
          halign = "center";
          valign = "top";
          shadow_passes = 1;
        }
        {
          monitor = "";
          text = "$DESC";
          color = "rgba(254, 254, 254, 1.0)";
          font_size = 28;
          font_family = "Sans";
          position = "0, -200";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
        }
      ];
    };
  };
}
