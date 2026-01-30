{
  flk,
  resize,
}:
[
  {
    description = "1Password";
    match = {
      window-class = {
        type = "exact";
        value = "1password";
        match-whole = false;
      };
      window-types = [ "normal" ];
    };
    apply = {
      size = {
        apply = "force";
        value = "${resize flk.host.monitor.width 0.5},${resize flk.host.monitor.height 0.6}";
      };
      placement = {
        apply = "force";
        value = 1; # default/centered
      };
    };
  }
]
