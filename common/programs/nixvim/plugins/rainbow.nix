{
  programs.nixvim.plugins.rainbow-delimiters = {
    enable = true;
    settings.highlight = [
      "RainbowDelimiterRed"
      "RainbowDelimiterYellow"
      "RainbowDelimiterBlue"
      "RainbowDelimiterOrange"
      "RainbowDelimiterGreen"
      "RainbowDelimiterViolet"
      "RainbowDelimiterCyan"
    ];
  };
}
