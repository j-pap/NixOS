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
    # configFile.kuriikwsfilterrc.General = {
    #   #EnableWebShortcuts = true;
    #   #UsePreferredWebShortcutsOnly = false;
    #   #PreferredWebShortcuts = "google,wikipedia,yahoo,youtube";
    #   DefaultWebShortcut = "sp";
    #   #KeywordDelimiter = ":";
    # };

    searchPlugins.webSearchKeywords = {
      enable = true;
      usePreferredOnly = false;
      preferred = [
        # "google"
        # "wikipedia"
        # "yahoo"
        # "youtube"
      ];
      default = "sp";
      delimiter = ":";
      extra = {
        home-manager = {
          name = "Home Manager";
          keys = [ "hm" ];
          query = "https://home-manager-options.extranix.com/?query=\\{@}&release=master";
        };
        nix-options = {
          name = "Nix Options";
          keys = [ "no" ];
          query = "https://search.nixos.org/options?channel=unstable&query=\\{@}";
        };
        nix-pkgs = {
          name = "Nix Pkgs";
          keys = [ "np" ];
          query = "https://search.nixos.org/packages?channel=unstable&query=\\{@}";
        };
        nix-wiki = {
          name = "NixOS Wiki";
          keys = [ "nw" ];
          query = "https://wiki.nixos.org/wiki/\\{@}";
        };
        startpage = {
          name = "Startpage";
          keys = [ "sp" ];
          query = "https://www.startpage.com/sp/search?query=\\{@}";
        };
      };
    };
  };

  # xdg.dataFile = import ./krunner.nix; # KRunner search providers
}
