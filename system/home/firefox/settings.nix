{
  lib,
  ffVariant,
  ffVersion,
  osConfig,
  ...
}: let
  host = osConfig.networking.hostName;
  isLaptop = osConfig.flake.host.isLaptop;
in lib.mkMerge [
  {
    /****************************************************************************
     * Betterfox                                                                *
     * "Ad meliora"                                                             *
     * version: 144                                                             *
     * url: https://github.com/yokoffing/Betterfox                              *
    ****************************************************************************/

    /****************************************************************************
     * SECTION: FASTFOX                                                         *
    ****************************************************************************/
    ### GENERAL ###
      "gfx.content.skia-font-cache-size" = 32;

    ### GFX ###
      "gfx.canvas.accelerated.cache-items" = 32768;
      "gfx.canvas.accelerated.cache-size" = 4096;
      "webgl.max-size" = 16384;

    ### DISK CACHE ###
      "browser.cache.disk.enable" = false;

    ### MEMORY CACHE ###
      "browser.cache.memory.capacity" = 131072;
      "browser.cache.memory.max_entry_size" = 20480;
      "browser.sessionhistory.max_total_viewers" = 4;
      "browser.sessionstore.max_tabs_undo" = 10;

    ### MEDIA CACHE ###
      "media.memory_cache_max_size" = 262144;
      "media.memory_caches_combined_limit_kb" = 1048576;
      "media.cache_readahead_limit" = 600;
      "media.cache_resume_threshold" = 300;

    ### IMAGE CACHE ###
      "image.cache.size" = 10485760;
      "image.mem.decode_bytes_at_a_time" = 65536;

    ### NETWORK ###
      "network.http.max-connections" = 1800;
      "network.http.max-persistent-connections-per-server" = 10;
      "network.http.max-urgent-start-excessive-connections-per-host" = 5;
      "network.http.request.max-start-delay" = 5;
      "network.http.pacing.requests.enabled" = false;
      "network.dnsCacheEntries" = 10000;
      "network.dnsCacheExpiration" = 3600;
      "network.ssl_tokens_cache_capacity" = 10240;

    ### SPECULATIVE LOADING ###
      "network.http.speculative-parallel-limit" = 0;
      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;
      "browser.urlbar.speculativeConnect.enabled" = false;
      "browser.places.speculativeConnect.enabled" = false;
      "network.prefetch-next" = false;
      "network.predictor.enabled" = false;


    /****************************************************************************
     * SECTION: SECUREFOX                                                       *
    ****************************************************************************/
    ### TRACKING PROTECTION ###
      "browser.contentblocking.category" = "strict";
      "privacy.trackingprotection.allow_list.baseline.enabled" = true;
      "browser.download.start_downloads_in_tmp_dir" = true;
      "browser.helperApps.deleteTempFileOnExit" = true;
      "browser.uitour.enabled" = false;
    # Settings→P&S→Website Privacy Preferences→'Tell websites not to sell or share my data'
      "privacy.globalprivacycontrol.enabled" = true;

    ### OCSP & CERTS / HPKP ###
      "security.OCSP.enabled" = 0; # 0=disabled, 1=enabled (default), 2=enabled for EV certificates only
      "security.csp.reporting.enabled" = false;

    ### SSL / TLS ###
      "security.ssl.treat_unsafe_negotiation_as_broken" = true;
      "browser.xul.error_pages.expert_bad_cert" = true;
      "security.tls.enable_0rtt_data" = false;

    ### DISK AVOIDANCE ###
      "browser.privatebrowsing.forceMediaMemoryCache" = true;
      "browser.sessionstore.interval" = 60000;

    ### SHUTDOWN & SANITIZING ###
      "browser.privatebrowsing.resetPBM.enabled" = true;
    # Settings→P&S→History→'Firefox will: Use custom settings for history'
      "privacy.history.custom" = true;

    ### SEARCH / URL BAR ###
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
    # Settings→Search→'Default Search Engine'→'Use this search engine in Private Windows' checkbox
      "browser.search.separatePrivateDefault.ui.enabled" = true;
    # Settings→Search→'Search Suggestions'→'Show search suggestions'
      "browser.search.suggest.enabled" = false;
    # Settings→P&S→'Firefox Data Collection and Use'→'Improve the Firefox Suggest experience'
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.groupLabels.enabled" = false;
    # Settings→P&S→History→'Remember search and form history'
      "browser.formfill.enable" = false;
    # display phishing characters
      "network.IDN_show_punycode" = true;

    ### PASSWORDS ###
      "signon.formlessCapture.enabled" = false;
      "signon.privateBrowsingCapture.enabled" = false;
      "network.auth.subresource-http-auth-allow" = 1; # 0=don't allow, 1=no cross-origin, 2=allow
      "editor.truncate_user_pastes" = false;

    ### MIXED CONTENT + CROSS-SITE ###
      "security.mixed_content.block_display_content" = true;
      "pdfjs.enableScripting" = false;

    ### EXTENSIONS ###
      "extensions.enabledScopes" = 7; # 1=profile, 2=user, 4=application, 8=system, 16=temporary, 31=all

    ### HEADERS / REFERERS ###
      "network.http.referer.XOriginTrimmingPolicy" = 2; # 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port

    ### CONTAINERS ###
    # Settings→General→Tabs→'Enable Container Tabs' checkbox
      "privacy.userContext.ui.enabled" = true;

    ### SAFE BROWSING ###
      "browser.safebrowsing.downloads.remote.enabled" = false;

    ### MOZILLA ###
    # Settings→P&S→Permissions→Notifications→Settings→'Block...'
      "permissions.default.desktop-notification" = 2; # 0=always ask (default), 1=allow, 2=block
    # Settings→P&S→Permissions→Location→Settings→'Block...'
      "permissions.default.geo" = 2; # 0=always ask (default), 1=allow, 2=block
      "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
      "browser.search.update" = false;
      "permissions.manager.defaultsUrl" = "";
      "extensions.getAddons.cache.enabled" = false;

    ### TELEMETRY ###
      "datareporting.policy.dataSubmissionEnabled" = false;
    # Settings→P&S→'Firefox Data Collection and Use'→'Send technical and interaction data to Mozilla'
      "datareporting.healthreport.uploadEnabled" = false;
    # Telemetry
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
    # Coverage
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
    # Firefox Home
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
    # Settings→P&S→'Firefox Data Collection and Use'→'Send daily usage ping to Mozilla'
      "datareporting.usage.uploadEnabled" = false;

    ### EXPERIMENTS ###
    # Settings→P&S→'Firefox Data Collection and Use'→'Install and run studies'
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";

    ### CRASH REPORTS ###
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;


    /****************************************************************************
     * SECTION: PESKYFOX                                                        *
    ****************************************************************************/
    ### MOZILLA UI ###
    # about:addons Recommendations
      "extensions.getAddons.showPane" = false;
    # about:addons Extensions→'Recommended Extensions'
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
    # Settings→P&S→'Firefox Data Collection and Use'→'Allow personalized extension recommendations'
      "browser.discovery.enabled" = false;
    # Settings→General→Startup→'Always check if Firefox is your default browser'
      "browser.shell.checkDefaultBrowser" = false;
    # Settings→General→Browsing→'Recommend extensions as you browse'
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    # Settings→General→Browsing→'Recommend features as you browse'
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    # Settings→'More from Mozilla'
      "browser.preferences.moreFromMozilla" = false;
    # disable about:config warning
      "browser.aboutConfig.showWarning" = false;
    # disable intro screens
      "browser.aboutwelcome.enabled" = false;
    # enable profiles
      "browser.profiles.enabled" = true;

    ### THEME ADJUSTMENTS ###
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userChrome.css/userContent.css
      "browser.compactmode.show" = true; # toolbar density option
      "browser.privateWindowSeparation.enabled" = false;

    ### AI ###
      "browser.ml.enable" = false;
      "browser.ml.chat.enabled" = false;
      "browser.ml.chat.menu" = false;
      "browser.tabs.groups.smart.enabled" = false;
      "browser.ml.linkPreview.enabled" = false;

    ### FULLSCREEN NOTICE ###
      "full-screen-api.transition-duration.enter" = "0 0"; # default=200 200
      "full-screen-api.transition-duration.leave" = "0 0"; # default=200 200
      "full-screen-api.warning.delay" = -1; # default=500
      "full-screen-api.warning.timeout" = 0; # default=3000

    ### URL BAR ###
      "browser.urlbar.trending.featureGate" = false;

    ### NEW TAB PAGE ###
    # clears default sites in shortcuts
      "browser.newtabpage.activity-stream.default.sites" = "";
    # Settings→Home→'Firefox Home Content'→'Support Firefox'
      "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
    # Settings→Home→'Firefox Home Content'→'Support Firefox'→'Sponsored shortcuts'
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    # Settings→Home→'Firefox Home Content'→'Recommended stories'
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    # Settings→Home→'Firefox Home Content'→'Recommended stories'→'Sponsored stories'
      "browser.newtabpage.activity-stream.showSponsored" = false;

    ### DOWNLOADS ###
      "browser.download.manager.addToRecentDocs" = false;

    ### PDF ###
      "browser.download.open_pdf_attachments_inline" = true;

    ### TAB BEHAVIOR ###
      "browser.bookmarks.openInTabClosesMenu" = false;
      "browser.menu.showViewImageInfo" = true;
      "findbar.highlightAll" = true;
      "layout.word_select.eat_space_to_next_word" = false;


    /****************************************************************************
     * START: MY OVERRIDES                                                      *
    ****************************************************************************/
    ### GFX ADV ###
    # Webrender (GPU)
      "gfx.webrender.all" = true;
      "gfx.webrender.precache-shaders" = true;
      "gfx.webrender.compositor" = true;
      #"gfx.webrender.compositor.force-enabled" = true;  # causes FF to crash when playing videos
    # Webrender (CPU - forces software rendering)
      #"gfx.webrender.software" = true;
      #"gfx.webrender.software.opengl" = true;
    # WebGL
      #"webgl.force-enabled" = true;
    # prefer GPU > CPU
      "layers.gpu-process.enabled" = true;
      #"layers.gpu-process.force-enabled" = true;  # 'Wayland does not work in the GPU process'
      "layers.mlgpu.enabled" = true;
      "media.gpu-process-decoder" = true;
      "media.hardware-video-decoding.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = lib.mkIf (lib.versionAtLeast ffVersion "137.0.0") true;
      "media.ffmpeg.vaapi.enabled" = lib.mkIf (lib.versionOlder ffVersion "137.0.0") true;

    ### TRACKING PROTECTION ADV ###
    # ETP
      #"privacy.trackingprotection.allow_list.convenience.enabled" = true;
    # Beacon
      "beacon.enabled" = false;
    # UITour
      "browser.uitour.url" = "";

    ### OCSP & CERTS / HPKP ADV ###
      "security.cert_pinning.enforcement_level" = 2; # 0=disabled, 1=allow user MitM (default), 2=strict

    ### SSL / TLS ADV ###
      "security.ssl.require_safe_negotiation" = true;

    ### DISK AVOIDANCE ADV ###
      "browser.sessionstore.privacy_level" = 2; # 0=everywhere (default), 1=unencrypted sites, 2=nowhere
      "browser.pagethumbnails.capturing_disabled" = true;

    ### SHUTDOWN & SANITIZING ADV ###
    # Time range to clear for 'Cookies Clear Data' & 'Clear History'
      "privacy.sanitize.timeSpan" = 0; # 0=everything, 1=last hour, 2=last two hours, 3=last four hours, 4=today, 5=last five minutes, 6=last twenty-four hours
    # Settings→P&S→'Cookies and Site Data'→'Clear Data...'
      "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
      "privacy.clearSiteData.cookiesAndStorage" = false; # keep false until it respects "allow" site exceptions
      "privacy.clearSiteData.cache" = true;
      "privacy.clearSiteData.formdata" = true;
      "privacy.clearSiteData.historyFormDataAndDownloads" = true;
      "privacy.clearSiteData.siteSettings" = false; # keep false until it respects "allow" site exceptions
    # Settings→P&S→History→'Clear History...' - ignores cookie site exceptions
      "privacy.clearHistory.browsingHistoryAndDownloads" = true;
      "privacy.clearHistory.cookiesAndStorage" = true;
      "privacy.clearHistory.cache" = true;
      "privacy.clearHistory.formdata" = true;
      "privacy.clearHistory.historyFormDataAndDownloads" = true;
      "privacy.clearHistory.siteSettings" = true;
      "privacy.cpd.siteSettings" = true;
      "privacy.cpd.offlineApps" = true;
      "privacy.cpd.openWindows" = true;
    # Settings→P&S→History→'Custom'→'Remember browsing and download history'
      "places.history.enabled" = false;
    # Settings→P&S→History→'Custom'→'Clear history when Firefox closes'
      "privacy.sanitize.sanitizeOnShutdown" = true;
    # Settings→P&S→History→'Custom'→'Clear history when Firefox closes'→Settings - respects cookie site exceptions
      "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
      "privacy.clearOnShutdown_v2.cache" = true;
      "privacy.clearOnShutdown_v2.formdata" = true;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
      "privacy.clearOnShutdown.siteSettings" = true;
      "privacy.clearOnShutdown_v2.siteSettings" = true;
      "privacy.clearOnShutdown.offlineApps" = true;

    ### SEARCH / URL BAR ADV ###
      "browser.urlbar.autoFill" = false;
    # Settings→Search→'Default Search Engine'
      "browser.urlbar.placeholderName" = "Startpage";
    # Settings→Search→'Default Search Engine'→'Use this search engine in Private Windows'→'Choose a different default search engine for Private Windows only'
      "browser.urlbar.placeholderName.private" = "Google (No AI)";
    # Settings→Search→'Search Suggestions'→'Show search suggestions'→'Show search suggestions ahead of browsing history in address bar results'
      "browser.urlbar.showSearchSuggestionsFirst" = false;
    # Settings→Search→'Search Suggestions'→'Show search suggestions'→'Show search suggestions in Private Windows'
      "browser.search.suggest.enabled.private" = false;
    # Settings→Search→'Search Suggestions'→'Show search suggestions'→'Show trending search suggestions'
      "browser.urlbar.suggest.trending" = false;
    # Settings→Search→'Search Suggestions'→'Show recent searches'
      "browser.urlbar.suggest.recentsearches" = false;

    ### HTTPS-ONLY MODE ###
    # private windows only
      #"dom.security.https_only_mode_pbm" = true;
    # normal & private windows
      "dom.security.https_only_mode" = true;
    # offer suggestions
      "dom.security.https_only_mode_error_page_user_suggestions" = true;

    ### DNS-over-HTTPS ###
    # Settings→P&S→'DNS over HTTPS'→'Enable DNS over HTTPS using:'
      "network.trr.mode" = 0; # 0=default, 2=DoH first, 3=DoH only, 5=off
      "network.trr.max-fails" = 5; # default=15
      #"network.trr.uri" = dohProvider;
      #"network.trr.custom_uri" = dohProvider;

    ### PROXY / SOCKS  IPv6 ###
    # Settings→General→'Network Settings'→'Settings...'→'Proxy DNS when using SOCKS v4'
      "network.proxy.socks_remote_dns" = true;
    # disable UNC paths
      "network.file.disable_unc_paths" = true;

    ### PASSWORDS ADV ###
    # Settings→P&S→Passwords→'Ask to save passwords'
      "signon.rememberSignons" = false;
    # Settings→P&S→Passwords→'Ask to save passwords'→'Fill usernames and passwords automatically'
      "signon.autofillForms" = false;
    # Settings→P&S→Passwords→'Ask to save passwords'→'Suggest strong passwords'
      "signon.generation.enabled" = false;
    # Settings→P&S→Passwords→'Ask to save passwords'→'Suggest Firefox Relay email masks to protect your email address'
      "signon.firefoxRelay.feature" = "disabled";
    # Settings→P&S→Passwords→'Ask to save passwords'→'Show alerts about passwords for breached websites'
      "signon.management.page.breach-alerts.enabled" = false;
      "signon.management.page.breachAlertUrl" = "";
      "browser.contentblocking.report.lockwise.enabled" = false;
      "browser.contentblocking.report.lockwise.how_it_works.url" = "";
    # disable autocomplete
      "signon.storeWhenAutocompleteOff" = false;

    ### ADDRESS + CREDIT CARD MANAGER ###
    # Settings→P&S→Autofill→'Save and fill addresses'
      "extensions.formautofill.addresses.enabled" = false;
    # Settings→P&S→Autofill→'Save and fill payment methods'
      "extensions.formautofill.creditCards.enabled" = false;

    ### MIXED CONTENT + CROSS-SITE ADV ###
      "browser.tabs.searchclipboardfor.middleclick" = false;

    ### EXTENSIONS ADV ###
      "extensions.postDownloadThirdPartyPrompt" = false;
      "privacy.resistFingerprinting.block_mozAddonManager" = true;
      "extensions.webextensions.restrictedDomains" = "";

    ### HEADERS / REFERERS ADV ###
    # 0=no-referrer, 1=same-origin, 2=strict-origin-when-cross-origin (default), 3=no-referrer-when-downgrade
      "network.http.referer.defaultPolicy.trackers" = 1;
      "network.http.referer.defaultPolicy.trackers.pbmode" = 1;

    ### CONTAINERS ADV ###
    # Settings→General→Tabs→'Enable Container Tabs'
      "privacy.userContext.enabled" = true;
    # open links in site-specific containers
      "browser.link.force_default_user_context_id_for_external_opens" = true;

    ### WEBRTC ###
      "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
      "media.peerconnection.ice.default_address_only" = true;
      "media.peerconnection.ice.no_host" = true;

    ### PLUGINS / DRM ###
    # Gecko Media Plugins
      "media.gmp-provider.enabled" = false;
    # Settings→General→'DRM Content'→'Play DRM-controlled content'
      "media.eme.enabled" = false;
      "browser.eme.ui.enabled" = false; # checkbox

    ### JIT ###
    # JavaScript
      "javascript.options.baselinejit" = false;
      "javascript.options.ion" = false;
      "javascript.options.jit_trustedprincipals" = false;
    # WebAssembly
      "javascript.options.wasm_baselinejit" = false;
      #"javascript.options.wasm_optimizingjit" = false; # breaks 1P extension
      "javascript.options.wasm_trustedprincipals" = false;
    # Asm.js
      "javascript.options.asmjs" = false;
    # Blinterp
      "javascript.options.blinterp" = false;

    ### MOZILLA ADV ###
    # disabling accessibility can improve performance
      "accessibility.force_disabled" = 1;
      "devtools.accessibility.enabled" = false;
    # disable the Firefox View tour from popping up
      "browser.firefox-view.feature-tour" = "{\"screen\":\"\",\"complete\":true}";
    # disable the OS' geolocation service
      "geo.provider.use_geoclue" = false;
    # disable region updates
      "browser.region.update.enabled" = false;
      "browser.region.network.url" = "";
    # disable auto-updates
      "app.update.auto" = false;
    # disable extension auto-updates
      "extensions.update.enabled" = false;

    ### DETECTION ###
    # PPA
      "toolkit.telemetry.dap.helper.url" = "";
      "toolkit.telemetry.dap.leader.url" = "";
    # SERP
      "browser.search.serpEventTelemetryCategorization.enabled" = false;
    # Assorted
      "doh-rollout.disable-heuristics" = true;
      "dom.security.unexpected_system_load_telemetry_enabled" = false;
      "messaging-system.rsexperimentloader.enabled" = false;
      "network.trr.confirmation_telemetry_enabled" = false;
      "security.app_menu.recordEventTelemetry" = false;
      "security.certerrors.mitm.priming.enabled" = false;
      "security.certerrors.recordEventTelemetry" = false;
      "security.protectionspopup.recordEventTelemetry" = false;
      "signon.recipes.remoteRecipes.enabled" = false;
      "privacy.trackingprotection.emailtracking.data_collection.enabled" = false;
      "messaging-system.askForFeedback" = true;

    ### MOZILLA UI ADV ###
    # Mozilla VPN
      "browser.vpn_promo.enabled" = false;
      "browser.contentblocking.report.hide_vpn_banner" = true;
    # Settings→General→Tabs→'Ask before closing multiple tabs'
      "browser.tabs.warnOnClose" = true;
    # use native Linux title bar buttons
      "widget.gtk.non-native-titlebar-buttons.enabled" = true;

    ### FONT APPEARANCE ###
    # Smoother font
      "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;

    ### URL BAR ADV ###
    # Settings→Search→'Address Bar'
      "browser.urlbar.suggest.history" = false; # Browsing history
      "browser.urlbar.suggest.bookmark" = true; # Bookmarks
      "browser.urlbar.suggest.openpage" = false; # Open tabs
      "browser.urlbar.suggest.topsites" = false; # Shortcuts
      "browser.urlbar.suggest.engines" = false; # Search engines
      "browser.urlbar.suggest.quickactions" = false; # Quick actions
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.amp" = false;
      "browser.urlbar.suggest.clipboard" = false;
      "browser.urlbar.suggest.mdn" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.realtimeOptIn" = false;
      "browser.urlbar.suggest.searched" = false;
      "browser.urlbar.suggest.yelp" = false;
      "browser.urlbar.suggest.yelpRealtime" = false;
    # suggestions
      "browser.urlbar.recentsearches.featureGate" = false;
      "browser.urlbar.richSuggestions.featureGate" = false;
      "browser.urlbar.showSearchTerms.featureGate" = false;

    ### AUTOPLAY ###
    # Settings→P&S→Permissions→Autoplay→Settings→'Default for all websites'
      "media.autoplay.default" = 5; # 0=Allow A/V, 1=Block Audio (default), 5=Block A/V
    # HTML5 media
      "media.autoplay.blocking_policy" = 2; # 0=sticky (default), 1=transient, 2=user

    ### NEW TAB PAGE ADV ###
    # Settings→Home→'Firefox Home Content'→'Web Search'
      "browser.newtabpage.activity-stream.showSearch" = false;
    # Settings→Home→'Firefox Home Content'→'Shortcuts'
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
    # Settings→Home→'Firefox Home Content'→'Recent activity'
      "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
    # Settings→Home→'Firefox Home Content'→'Recent activity'→'Visited pages'
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
    # Settings→Home→'Firefox Home Content'→'Recent activity'→'Bookmarks'
      "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
    # Settings→Home→'Firefox Home Content'→'Recent activity'→'Most recent download'
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;

    ### POCKET ###
      "extensions.pocket.enabled" = false;
      "extensions.pocket.api" = " ";
      "extensions.pocket.oAuthConsumerKey" = " ";
      "extensions.pocket.site" = " ";
      "extensions.pocket.showHome" = false;

    ### TAB BEHAVIOR ADV ###
    # behavior of pages opened by JavaScript
      "browser.link.open_newwindow.restriction" = 0; # 0=force into tabs, 1=let open in new windows, 2(default)=catch new windows
    # open bookmarks in new tabs
      "browser.tabs.loadBookmarksInTabs" = true;
      "browser.tabs.loadBookmarksInBackground" = true;
    # prevent scripts from moving/resizing windows
      "dom.disable_window_move_resize" = true;
    # leave the browser window open even after closing the last tab
      #"browser.tabs.closeWindowWithLastTab" = false;
    # limit what can cause a pop-up
      "dom.popup_allowed_events" = "click dblclick";

    ### KEYBOARD AND SHORTCUTS ###
    # disable websites from overriding keyboard shortcuts
      "permissions.default.shortcuts" = 2; # 0=always ask (default), 1=allow, 2=block

    ### ACCESSIBILITY AND USABILITY ###
    # spell-check
      "layout.spellcheckDefault" = 0; # 0=none, 1=multi-line, 2=multi & single-line

    ### BOOKMARK MANAGEMENT ###
    # limit bookmark backups
      "browser.bookmarks.max_backups" = 1; # default=15

    ### ZOOM AND DISPLAY SETTINGS ###
    # zoom only text
      "browser.zoom.full" = false;

    ### DEVELOPER TOOLS ###
    # wrap long lines when viewing source
      "view_source.wrap_long_lines" = true;
      "devtools.debugger.ui.editor-wrapping" = true;


    /****************************************************************************
     * CUSTOM                                                                   *
    ****************************************************************************/

    # disable touchpad's pinch-to-zoom
      "apz.gtk.touchpad_pinch.enabled" = false;

    # enable mobile bookmarks
      "browser.bookmarks.showMobileBookmarks" = true;

    # native Linux file browser
      "widget.use-xdg-desktop-portal.file-picker" = 1;

    # Switch tabs by scrolling
      "toolkit.tabbox.switchByScrolling" = true;

    ### VERTICAL TABS ###
    # Settings→General→'Browser Layout'→'Vertical tabs'
      "sidebar.verticalTabs" = true;
      "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
    # vertical tab bar visibility
      "sidebar.expandOnHover" = true; # checkbox to enable
      "sidebar.visibility" = "expand-on-hover"; # default=always-show
    # left or right tab bar
      "sidebar.position_start" = true; # left=true, right=false(default)
    # sidebar contents
      "sidebar.main.tools" = "syncedtabs,history,bookmarks";
    # decrease animation time
      "sidebar.animation.expand-on-hover.duration-ms" = 100; # default=400
    # disable animation
      #"sidebar.animation.enabled" = false; # default=true

    ### ACCOUNT PROMOS ###
      "identity.fxaccounts.toolbar.pxiToolbarEnabled.monitorEnabled" = false;
      "identity.fxaccounts.toolbar.pxiToolbarEnabled.relayEnabled" = false;
      "identity.fxaccounts.toolbar.pxiToolbarEnabled.vpnEnabled" = false;

    ### SYNC ACCOUNT ###
      "identity.fxaccounts.account.device.name" = host;
    # only syncing addons/bookmarks/prefs/tabs
      "services.sync.declinedEngines" = "addresses,creditcards,forms,history,passwords";
      "services.sync.engine.addons" = true;
      "services.sync.engine.addresses" = false;
      "services.sync.engine.bookmarks" = true;
      "services.sync.engine.creditcards" = false;
      "services.sync.engine.history" = false;
      "services.sync.engine.passwords" = false;
      "services.sync.engine.prefs" = true;
      "services.sync.engine.tabs" = true;

    ### TOOLBAR CUSTOMIZATION ###
      "browser.uiCustomization.navBarWhenVerticalTabs" = ''
        ["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","addon_simplelogin-browser-action","vpn_proton_ch-browser-action","unified-extensions-button","fxa-toolbar-menu-button","alltabs-button"]
      '';
      "browser.uicustomization.state" = ''
        {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","_testpilot-containers-browser-action","sponsorblocker_ajay_app-browser-action","magnolia_12_34-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","_76ef94a4-e3d0-4c6f-961a-d38a429a332b_-browser-action","canconfig.networking.hostNamevasblocker_kkapsner_de-browser-action","_4d5b7a5e-5232-9e45-97f4-f8e1ca2626e5_-browser-action"],"nav-bar":["reset-pbm-toolbar-button","workspaces-toolbar-button","firefox-view-button","back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","vertical-spacer","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","addon_simplelogin-browser-action","vpn_proton_ch-browser-action","unified-extensions-button","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"],"nora-statusbar":["screenshot-button","fullscreen-button","status-text"]},"seen":["reset-pbm-toolbar-button","magnolia_12_34-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","undo-closed-tab","developer-button","workspaces-toolbar-button","_76ef94a4-e3d0-4c6f-961a-d38a429a332b_-browser-action","_testpilot-containers-browser-action","addon_darkreader_org-browser-action","addon_simplelogin-browser-action","vpn_proton_ch-browser-action","canvasblocker_kkapsner_de-browser-action","ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action","screenshot-button","_4d5b7a5e-5232-9e45-97f4-f8e1ca2626e5_-browser-action"],"dirtyAreaCache":["unified-extensions-area","nav-bar","TabsToolbar","vertical-tabs","nora-statusbar","PersonalToolbar","toolbar-menubar"],"currentVersion":23,"newElementCount":3}
      '';


    /****************************************************************************
     * SECTION: SMOOTHFOX                                                       *
    ****************************************************************************/
    # visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js

    ### OPTION: SHARPEN SCROLLING ###
      "general.smoothScroll" = true; # DEFAULT
      #"mousewheel.min_line_scroll_amount" 10; # adjust this number to your liking; default=5
      "general.smoothScroll.mouseWheel.durationMinMS" = 80; # default=50
      "general.smoothScroll.currentVelocityWeighting" = "0.15"; # default=.25
      "general.smoothScroll.stopDecelerationWeighting" = "0.6"; # default=.4

    ### SLOW TOUCHPAD SCROLLING ###
      "mousewheel.default.delta_multiplier_x" = 30; # default=100
      "mousewheel.default.delta_multiplier_y" = 30; # default=300
    ## match touchpad's scrolling via mousewheel
      "mousewheel.min_line_scroll_amount" = 120;


    /****************************************************************************
     * END: BETTERFOX                                                           *
    ****************************************************************************/
  }

  #(lib.mkIf (host == "T1") {
  (lib.mkIf (!isLaptop) {
    ### CAPTIVE PORTAL DETECTION - NO MOBILE DEVICES ###
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;
  })

  (lib.mkIf (ffVariant == "floorp") {
    /****************************************************************************
     * Floorp version: 12.2.x                                                   *
    ****************************************************************************/
    # hide welcome page
      "floorp.browser.welcome.page.shown" = true;

    # Hub→'Tab & Appearance'→'UI Customization'
      "floorp.design.configs" = ''
        {"globalConfigs":{"faviconColor":false,"userInterface":"lepton","appliedUserJs":""},"tabbar":{"tabbarStyle":"horizontal","tabbarPosition":"default","multiRowTabBar":{"maxRowEnabled":false,"maxRow":3}},"tab":{"tabScroll":{"enabled":true,"reverse":false,"wrap":false},"tabMinHeight":30,"tabMinWidth":76,"tabPinTitle":false,"tabDubleClickToClose":false,"tabOpenPosition":-1},"uiCustomization":{"navbar":{"position":"top","searchBarTop":false},"display":{"disableFullscreenNotification":false,"deleteBrowserBorder":false,"hideUnifiedExtensionsButton":false},"special":{"optimizeForTreeStyleTab":false,"hideForwardBackwardButton":false,"stgLikeWorkspaces":false},"multirowTab":{"newtabInsideEnabled":false},"bookmarkBar":{"focusExpand":false},"qrCode":{"disableButton":false},"disableFloorpStart":true}}
      '';
    # Hub→'Tab & Appearance'→'Tabs'→'New tab opening position'
      "floorp.browser.tabs.openNewTabPosition" = -1; # -1=follow Firefox (default), 0=open at end, 1=open after current

    # Hub→'Panel Sidebar'→'Basic Settings'
      # 'Enable/Disable'
        "floorp.panelSidebar.enabled" = false;
      # 'Other Panel Sidebar Settings'
        "floorp.panelSidebar.config" = ''
          {"globalWidth":400,"autoUnload":false,"position_start":true,"displayed":true,"webExtensionRunningEnabled":false}
        '';
    # Hub→'Panel Sidebar'→'Panel List'
      /*
      "floorp.panelSidebar.data" = ''
        {"data":[{"id":"default-panel-bookmarks","type":"static","width":0,"url":"floorp//bookmarks"},{"id":"default-panel-history","type":"static","width":0,"url":"floorp//history"},{"id":"default-panel-downloads","type":"static","width":0,"url":"floorp//downloads"},{"id":"default-panel-notes","type":"static","width":0,"url":"floorp//notes"},{"id":"default-panel-translate-google-com","type":"web","width":0,"url":"https://translate.google.com","userContextId":null,"zoomLevel":null},{"id":"panel-1761608593319","type":"web","width":300,"url":"https://mail.proton.me","icon":"","userContextId":null,"zoomLevel":null,"userAgent":true,"extensionId":null}]}
      '';
      */

    # Hub→'Mouse Gestures'→'General Settings'→'Enable mouse gestures'
      "floorp.mousegesture.enabled" = false;
    # Hub→'Mouse Gestures'→'General Settings/Gesture Actions'
      #"floorp.mousegesture.config" = '''';

    # Hub→'Workspaces'→'Basic Settings'
      # 'Enable/Disable'→'Enable workspace feature'
        "floorp.workspaces.enabled" = true;
      # 'Other Workspace Settings'
        "floorp.workspaces.v4.config" = ''
          {"manageOnBms":false,"showWorkspaceNameOnToolbar":true,"closePopupAfterClick":true}
        '';

    # Hub→'Keyboard Shortcuts'→'Basic Settings'→'Enable/Disable'→'Enable custom keyboard shortcuts'
      "floorp.keyboardshortcut.enabled" = false;
    # Hub→'Keyboard Shortcuts'→'Shortcuts'
      #"floorp.keyboardshortcut.config" = '''';

    # Hub→'Web Apps'→'Basic Settings'→'Enable/Disable'→'Enable Progressive Web Apps'
      "floorp.browser.ssb.enabled" = true;
    # Hub→'Web Apps'→'Basic Settings'→'Other Settings'→'Show Toolbar'
      "floorp.browser.ssb.config" = ''
        {"showToolbar":true}
      '';

    # Hub→'Profile and Account'→'Mozilla Account Sync Settings'→'Floorp Feature Sync Settings'→'Sync Floorp Notes to Mozilla Account (Experimental)'
      #"services.sync.prefs.sync.floorp.browser.note.memos" = true;

    # disable PiP mode
      "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
  })
]
