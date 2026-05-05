{
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  DisableFeedbackCommands = true;
  DisableFirefoxStudies = true;
  DisableFormHistory = true;
  DisableTelemetry = true;
  DisplayBookmarksToolbar = "newtab";
  DNSOverHTTPS = {
    Enabled = false;
    Fallback = false;
    Locked = false;
    #ProviderURL = dohProvider;
  };
  EnableTrackingProtection = {
    Locked = false;
    Value = true;
    Cryptomining = true;
    EmailTracking = true;
    Fingerprinting = true;
  };
  ExtensionSettings = import ./extensions.nix;
  ExtensionUpdate = false;
  FirefoxHome = {
    Locked = true;
    Highlights = false;
    Pocket = false;
    Search = false;
    Snippets = false;
    SponsoredPocket = false;
    SponsoredStories = false;
    SponsoredTopSites = false;
    Stories = false;
    TopSites = false;
  };
  FirefoxSuggest = {
    Locked = true;
    ImproveSuggest = false;
    SponsoredSuggestions = false;
    WebSuggestions = false;
  };
  GenerativeAI = {
    Enabled = false;
  };
  HardwareAcceleration = true;
  HttpsOnlyMode = "force_enabled";
  NetworkPrediction = false;
  NewTabPage = false;
  NoDefaultBookmarks = true;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  Permissions = {
    Autoplay.Default = "block-audio-video";
    Camera.BlockNewRequests = true;
    Location.BlockNewRequests = true;
    Microphone.BlockNewRequests = true;
    Notifications.BlockNewRequests = true;
  };
  SanitizeOnShutdown = {
    Locked = true;
    Cache = true;
    Cookies = true;
    Downloads = true;
    FormData = true;
    History = true;
    OfflineApps = true;
    Sessions = false;
    SiteSettings = false;
  };
  SearchBar = "unified";
  SearchEngines = {
    #Add = [ ];
    #Default = "";
    Remove = [
      "Amazon.com"
      "eBay"
      "Perplexity"
    ];
  };
  SearchSuggestEnabled = false;
  ShowHomeButton = false;
  StartDownloadsInTempDirectory = true;
  UserMessaging = {
    ExtensionRecommendations = false;
    FeatureRecommendations = false;
    MoreFromMozilla = false;
    SkipOnboarding = true;
    UrlbarInterventions = false;
  };
}
