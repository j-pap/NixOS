{
  flk,
}:
{
  # Settings -> Keyboard -> Keyboard Shortcuts
  imports = [
    ./accessibility.nix
    ./launchers.nix
    ./navigation.nix
    ./screenshots.nix
    ./sound.nix
    ./system.nix
    ./typing.nix
    ./windows.nix
    (import ./custom.nix { inherit flk; })
  ];

  dconf.settings = {
    # Settings -> Keyboard -> Keyboard Shortcuts -> Activities Overview Shortcut
    #"org/gnome/mutter".overlay-key = "Super";
  };
}
