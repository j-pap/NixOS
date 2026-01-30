{
  # System Settings -> Search
  programs.plasma = {
    # File Search -> File indexing
    configFile.baloofilerc."Basic Settings".Indexing-Enabled = false;

    # Plasma Search -> Configure KRunner...
    krunner = {
      position = "center"; # center or top
      activateWhenTypingOnDesktop = false;
      historyBehavior = "disabled"; # disabled, enableSuggestions, enableAutoComplete
    };

    # Plasma Search -> File Search
    configFile.krunnerrc.Plugins.baloosearchEnabled = false;

    # Plasma Search -> Web Search Keywords -> Configure
    configFile.kuriikwsfilterrc.General = {
      #EnableWebShortcuts = true;
      #UsePreferredWebShortcutsOnly = false;
      #PreferredWebShortcuts = "google,wikipedia,yahoo,youtube";
      DefaultWebShortcut = "sp";
      #KeywordDelimiter = ":";
    };
  };

  xdg.dataFile = import ./krunner.nix; # KRunner search providers
}
