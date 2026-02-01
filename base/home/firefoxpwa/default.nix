{
  imports = [
    ./pocketcasts.nix
  ];

  programs.firefoxpwa = {
    enable = true;
    settings.config = {
      runtime_enable_wayland = true;
      runtime_use_portals = true;
    };
  };
}
