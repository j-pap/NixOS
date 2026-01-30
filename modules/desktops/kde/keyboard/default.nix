{
  flk,
}:
{
  # System Settings -> Keyboard -> Shortcuts
  programs.plasma = {
    krunner.shortcuts = {
      launch = [
        "Search"
        #"Alt+F2"
        #"Alt+Space"
        "Meta+Space"
      ];
      runCommandOnClipboard = [
        #"Alt+Shift+F2"
      ];
    };

    spectacle.shortcuts = import ./spectacle.nix;

    hotkeys.commands = import ./hotkeys.nix { inherit flk; }; # Custom

    shortcuts = import ./shortcuts.nix; # System Services
  };
}
