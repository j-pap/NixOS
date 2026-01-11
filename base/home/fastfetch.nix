{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "chafa";
        source = ../logo.png;
        #source = "NixOS_small";
        width = 20;
        padding = {
          left = 4;
          top = 2;
        };
      };
      display = {
        color = {
          #title = "";
          keys = "cyan";
          separator = "yellow";
          #output = "";
        };
        separator = "   ";
      };
      modules = [
        {
          type = "title";
          format = "{user-name-colored}{at-symbol-colored}{host-name-colored}";
          color = {
            #user = "";
            #at = "";
            #host = "";
          };
        }
        "separator"
        {
          type = "os";
          key = "OS ";
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = " ├ ";
          format = "{sysname} {release}";
        }
        {
          type = "shell";
          key = " ├ ";
          format = "{pretty-name} {version}";
        }
        {
          type = "terminal";
          key = " ├ ";
          format = "{pretty-name} {version}";
        }
        {
          type = "wm";
          key = " ├ ";
          format = "{pretty-name}{?version} {version}{?} ({protocol-name})";
        }
        {
          type = "packages";
          key = " └ 󰏖";
        }
        "break"
        {
          type = "host";
          key = "PC 󰇅";
          format = "{vendor} {name}";
        }
        {
          type = "cpu";
          key = " ├ ";
          format = "{name} ({cores-logical}) @ {freq-max}";
        }
        {
          type = "gpu";
          key = " ├ 󰢮";
          format = "{vendor} {name}{?frequency} @ {frequency} GHz{?}";
        }
        {
          type = "memory";
          key = " ├ ";
          format = "{used} / {total} ({percentage})";
        }
        {
          type = "disk";
          key = " ├ 󰋊";
          format = "{size-used} / {size-total} ({size-percentage}) - {filesystem}";
        }
        {
          type = "uptime";
          key = " └ ";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}
