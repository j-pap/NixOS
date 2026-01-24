{
  lib,
  pkgs,
  cosmicLib,
  flk,
  ...
}:
let
  inherit (cosmicLib.cosmic) mkRON;
in
{
  wayland.desktopManager.cosmic = {
    # COSMIC Settings -> Input devices -> Keyboard -> Keyboard shortcuts
    shortcuts = import ./shortcuts.nix {
      inherit
        lib
        pkgs
        cosmicLib
        flk
        ;
    };

    compositor = {
      # COSMIC Settings -> Input devices -> Keyboard -> Input Sources
      /*
        xkb_config = {
          #rules = "";
          #model = "pc104";
          #layout = "us";
          #variant = "";
          #options = mkRON "optional" "terminate:ctrl_alt_bksp";
          #repeat_delay = 600;
          #repeat_rate = 25;
        };
      */

      # COSMIC Settings -> Input devices -> Keyboard -> Numlock
      keyboard_config.numlock_state = mkRON "enum" "BootOff"; # BootOff, BootOn, LastBoot

      # COSMIC Settings -> Input devices -> Mouse
      #input_default = { };

      # COSMIC Settings -> Input devices -> Touchpad
      input_touchpad = {
        state = mkRON "enum" "DisabledOnExternalMouse"; # Enabled, DisabledOnExternalMouse, Disabled
        left_handed = mkRON "optional" false;
        acceleration = mkRON "optional" {
          #speed = 0.03853627492575307; # 60
          speed = mkRON "raw" "0.03853627492575307"; # 60
          profile = mkRON "optional" (mkRON "enum" "Adaptive"); # Adaptive, Flat
        };
        disable_while_typing = mkRON "optional" true;
        # Click Behavior
        click_method = mkRON "optional" (mkRON "enum" "Clickfinger"); # Clickfinger, ButtonAreas
        tap_config = mkRON "optional" {
          enabled = true;
          button_map = mkRON "optional" (mkRON "enum" "LeftRightMiddle"); # LeftRightMiddle, LeftMiddleRight
          drag = true;
          drag_lock = true;
        };
        # Scrolling
        scroll_config = mkRON "optional" {
          method = mkRON "optional" (mkRON "enum" "TwoFinger"); # TwoFinger, Edge, OnButtonDown, NoScroll
          scroll_button = mkRON "optional" 0;
          scroll_factor = mkRON "optional" 1.0;
          natural_scroll = mkRON "optional" true;
        };
      };
    };
  };
}
