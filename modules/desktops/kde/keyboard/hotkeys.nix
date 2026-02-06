{
  flk,
}:
{
  "1password" = {
    name = "Launch 1Password";
    key = "Meta+?";
    command = "1password --toggle";
  };
  "color-chooser" = {
    name = "Launch Color Chooser";
    key = "Meta+Print";
    command = "kcolorchooser";
  };
  "darkman" = {
    name = "Toggle Darkman";
    key = "Meta+Shift+T";
    command = "darkman toggle";
  };
  "firefox" = {
    name = "Launch Browser";
    key = "Meta+B";
    command = "${flk.browser}";
  };
  "firefox-private" = {
    name = "Launch Browser (Private)";
    key = "Meta+Alt+B";
    command = "${flk.browser} --private-window";
  };
  "nvim" = {
    name = "Launch Neovim";
    key = "Meta+Shift+N";
    command = "${flk.terminal} nvim";
  };
  "terminal" = {
    name = "Launch Terminal";
    key = "Meta+Return";
    command = "${flk.terminal}";
  };
  "yazi" = {
    name = "Launch Yazi";
    key = "Meta+Shift+Y";
    command = "${flk.terminal} yazi";
  };
}
