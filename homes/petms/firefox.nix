{ pkgs, flake-inputs, ...}: let
  finalPackage = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = {
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

  keepassxcProxyBin = "${pkgs.keepassxc}/bin/keepassxc-proxy";

  keepassxcNmConfig = pkgs.writeText "org.keepassxc.keepassxc_browser.json" (builtins.toJSON {
    name = "org.keepassxc.keepassxc_browser";
    description = "KeePassXC integration with native messaging support";
    type = "stdio";
    path = keepassxcProxyBin;
    allowed_extensions = ["keepassxc-browser@keepassxc.org"];
  });

  sandboxedPackage = ((flake-inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  }) {
    config = { sloth, ... }: {
      app.package = finalPackage;
      dbus.policies = {
        "org.gnome.SessionManager" = "talk";
        "org.a11y.Bus" = "talk";
        "org.gtk.vfs.*" = "talk";
        "org.freedesktop.ScreenSaver" = "talk";
        "org.freedesktop.FileManager1" = "talk";
        "org.freedesktop.Notifications" = "talk";
        "org.freedesktop.portal.*" = "talk";
        "org.freedesktop.UPower" = "talk";

        "org.mozilla.firefox_beta.*" = "own";
        "org.mpris.MediaPlayer2.firefox.*" = "own";
        "org.mozilla.firefox.*" = "own";
      };
      gpu.enable = true;
      fonts.enable = true;
      locale.enable = true;
      etc.sslCertificates.enable = true;
      bubblewrap = {
        network = true;
        bind.ro = [
          ["${finalPackage}/lib/firefox" "/app/etc/firefox"]
          [keepassxcProxyBin "/app/bin/keepassxc-proxy"]
          [
            (toString keepassxcNmConfig)
            (sloth.concat' sloth.homeDir "/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json")
          ]
        ];
        bind.rw = [
          (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
          (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache_db")
          (sloth.concat' sloth.xdgCacheHome "/fontconfig")
          (sloth.concat' sloth.homeDir "/.mozilla")
          (sloth.concat' sloth.xdgCacheHome "/mozilla")
          (sloth.concat' sloth.homeDir "/Downloads")
          (sloth.concat' sloth.runtimeDir "/doc")
          (sloth.concat' sloth.runtimeDir "/app/org.keepassxc.KeePassXC")
        ];
        tmpfs = ["/tmp"];
        sockets = {
          wayland = true;
          pulse = true;
          pipewire = true;
        };
        apivfs.proc = true;
      };
    };
  }).config.env;
in {

  home.packages = [ sandboxedPackage ];

}
