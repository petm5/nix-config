{

  programs.firefox = {
    enable = true;
    policies = {
      SearchEngines.Default = "DuckDuckGo";
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      DisableFirefoxStudies = true;
      DisableProfileRefresh = true;
      DontCheckDefaultBrowser = true;
      HttpsOnlyMode = "force_enabled";
      DisableSecurityBypass = {
        InvalidCertificate = true;
      };
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
      };
      DisabledCiphers = {
        TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 = true;
        TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 = true;
        TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA = true;
        TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA = true;
        TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA = true;
        TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA = true;
        TLS_DHE_RSA_WITH_AES_128_CBC_SHA = true;
        TLS_DHE_RSA_WITH_AES_256_CBC_SHA = true;
        TLS_RSA_WITH_AES_128_GCM_SHA256 = true;
        TLS_RSA_WITH_AES_256_GCM_SHA384 = true;
        TLS_RSA_WITH_AES_128_CBC_SHA = true;
        TLS_RSA_WITH_AES_256_CBC_SHA = true;
        TLS_RSA_WITH_3DES_EDE_CBC_SHA = true;
      };
      DisableFeedbackCommands = true;
      DisableSetDesktopBackground = true;
      DNSOverHTTPS = {
          Enabled = true;
          ProviderURL = "https://cloudflare-dns.com/dns-query";
          Locked = true;
      };
      NoDefaultBookmarks = true;
      Extensions = {
        Install = [ "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi" ];
      };
      EncryptedMediaExtensions = {
        Enabled = false;
        Locked = true;
      };
      FirefoxHome = {
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      SearchSuggestEnabled = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };
      Preferences = {
        "gfx.webrender.precache-shaders" = true;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;
        "media.memory_cache_max_size" = 65536;
        "network.http.max-connections" = 1800;
        "network.ssl_tokens_cache_capacity" = 10240;
        "browser.contentblocking.category" = "strict";
        "browser.uitour.enabled" = false;
        "privacy.globalprivacycontrol.enabled" = true;
        "security.OCSP.enabled" = false;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "security.tls.enable_0rtt_data" = false;
        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "pdfjs.enableScripting" = false;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.privatebrowsing.vpnpromourl" = "";
        "extensions.getAddons.showPane" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "general.smoothScroll" = true;
      };
    };
  };

}
