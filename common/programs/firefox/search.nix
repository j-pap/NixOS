{
  lib,
  pkgs,
  ...
}: {
  default = "startpage";
  privateDefault = "google-no-ai";
  force = true;

  engines = {
    "bing".metaData.hidden = true;
    "ebay@search.mozilla.orgdefault".metaData.hidden = true;
    "perplexity".metaData.hidden = true;
    "perplexity@search.mozilla.orgdefault".metaData.hidden = true;
    "you.com".metaData.hidden = true;

    google-no-ai = {
      name = "Google (No AI)";
      definedAliases = [ "@g" ];
      icon = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Google_Favicon_2025.svg/330px-Google_Favicon_2025.svg.png";
      urls = lib.singleton {
        template = "https://www.google.com/search";
        params = [
          {
            name = "udm";
            value = "14";
          }
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      };
    };

    home-manager-options = {
      name = "Home Manager Options";
      definedAliases = [ "@hm" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://home-manager-options.extranix.com/";
        params = [
          {
            name = "query";
            value = "{searchTerms}";
          }
          {
            name = "release";
            value = "master";
          }
        ];
      };
    };

    nix-packages = {
      name = "Nix Packages";
      definedAliases = [ "@np" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "channel";
            value = "unstable";
          }
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      };
    };

    nixos-options = {
      name = "NixOS Options";
      definedAliases = [ "@no" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://search.nixos.org/options";
        params = [
          {
            name = "channel";
            value = "unstable";
          }
          {
            name = "type";
            value = "options";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      };
    };

    nixos-wiki = {
      name = "NixOS Wiki";
      definedAliases = [ "@nw" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://wiki.nixos.org/wiki/{searchTerms}";
      };
    };

    startpage = {
      name = "Startpage";
      definedAliases = [ "@sp" ];
      icon = "https://www.startpage.com/sp/cdn/favicons/favicon-gradient.ico";
      urls = lib.singleton {
        template = "https://www.startpage.com/sp/search?query={searchTerms}";
      };
    };
  };
}
