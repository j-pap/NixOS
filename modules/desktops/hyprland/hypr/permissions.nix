{
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    ###################
    ### PERMISSIONS ###
    ###################
    # https://wiki.hypr.land/Configuring/Permissions/

    #ecosystem.enforce_permissions = true;

    # permission = regex, permission, mode
    permission = [
      #"${lib.escapeRegex (pkgs.xdg-desktop-portal-hyprland + "/libexec/.xdg-desktop-portal-hyprland-wrapped")}, screencopy, allow"
      #"${lib.escapeRegex (pkgs.xdg-desktop-portal-gtk + "/libexec/.xdg-desktop-portal-gtk-wrapped")}, screencopy, allow"
      #"${lib.escapeRegex (pkgs.xdg-desktop-portal-kde + "/libexec/.xdg-desktop-portal-kde-wrapped")}, screencopy, allow"
    ];
  };
}
