{
  osConfig,
  ...
}:
let
  flk = osConfig.flake;
in
{
  programs.nixvim.plugins.markdown-preview = {
    enable = true;
    settings = {
      auto_close = 0;
      browser = flk.browser;
      combine_preview = 1;
      combine_preview_auto_refresh = 1;
      filetypes = [ "markdown" ];
      preview_options = {
        disable_sync_scroll = 0;
        sync_scroll_type = "relative";
      };
    };
  };
}
