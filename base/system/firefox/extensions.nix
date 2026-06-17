let
  mkExt = guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${guid}/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in
builtins.listToAttrs [
  (mkExt "{d634138d-c276-4fc8-924b-40a0ea21d284}") # 1Password
  (mkExt "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}") # Augmented Steam
  (mkExt "CanvasBlocker@kkapsner.de") # CanvasBlocker
  (mkExt "addon@darkreader.org") # Dark Reader
  (mkExt "@testpilot-containers") # Firefox Multi-Account Containters
  (mkExt "firefoxpwa@filips.si") # Firefox PWA
  (mkExt "vpn@proton.ch") # Proton VPN
  (mkExt "addon@simplelogin") # SimpleLogin
  (mkExt "sponsorBlocker@ajay.app") # SponsorBlock
  (mkExt "extension@tabliss.io") # Tabliss
  (mkExt "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}") # TTV LOL PRO
  (mkExt "uBlock0@raymondhill.net") # uBlock Origin
]
