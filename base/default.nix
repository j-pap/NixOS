{
  config,
  lib,
  pkgs,
  flk,
  inputs,
  ...
}:
let
  useNixPlugins = true;
in
{
  imports = (import ../modules ++ import ./system) ++ [ ../libs ];

  options.flake = {
    browser = lib.mkOption {
      default = "firefox";
      type = lib.types.str;
    };
    terminal = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
    user = lib.mkOption {
      default = "jays";
      type = lib.types.str;
    };
  };

  config = {
    _module.args = {
      nixSecrets =
        assert lib.assertMsg (useNixPlugins) "nixSecrets cannot be accessed because nix-plugins is not enabled.";
        assert lib.assertMsg (builtins ? extraBuiltins.readSops)
          "The extraBuiltin 'readSops' could not be read. Verify that 'nix.settings.plugin-files' & 'nix.settings.extra-builtins-file' are defined correctly.";
        builtins.extraBuiltins.readSops ../secrets/eval-secrets.nix;
    };

    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];
      consoleLogLevel = 3; # Errors only // sets 'loglevel=' kernelParam
      initrd.verbose = false;
      kernel.sysctl."vm.swappiness" = lib.mkDefault 0; # Prioritize swap for hibernation
      kernelParams = lib.mkBefore [
        "quiet"
        "splash"
        "udev.log_level=3" # Errors only
        "rd.udev.log_level=3" # Errors only
        "systemd.show_status=auto" # Errors only
        "vt.global_cursor_default=0" # Disable TTY cursor blink @ boot
        "fbcon=nodefer" # Clears UEFI logo quicker
        "plymouth.use-simpledrm" # Faster splash
      ];
      tmp.cleanOnBoot = true;
    };

    console = {
      #font = "Lat2-Terminus16";
      keyMap = "us";
    };

    environment = {
      etc = {
        # Enable TTY cursor blink post-boot
        issue = {
          mode = "0444";
          text = ''

            [1;32m<<< Welcome to NixOS ${lib.version} (\m) - \l >>>[0m

            Run 'nixos-help' for the NixOS manual.
            [?12h[?25h
          '';
        };
        "nix/nixpkgs".source = "${pkgs.path}"; # Symlink for nix.nixPath
      };

      pathsToLink = [ "/share/backgrounds" ];

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      # To use a stable version, add 'stable.' to the beginning of the package:
      # pkgs.stable.wget
      systemPackages = builtins.attrValues {
        inherit (pkgs)
          # ASCII Art
          asciiquarium      # Fishies swimming
          cbonsai           # Bonsai growing

          # Files
          caligula          # Disk imaging
          cryptomator       # Encrypt cloud files
          exiftool          # File metadata
          file              # File information
          libarchive        # ISO extraction | 'bsdtar -xf IsoFile.iso OutputFile'
          p7zip             # Zip encryption
          unzip             # Zip files
          unrar             # Rar files
          zip               # Zip files

          # Hardware
          dmidecode         # Firmware | 'dmidecode -s bios-version'
          ffmpeg-full       # Hardware video acceleration
          mesa-demos        # OpenGL info
          libva-utils       # VAAPI | 'vainfo'
          lm_sensors        # Hardware sensors | 'sensors-detect'
          lshw              # Hardware config
          nvme-cli          # Manage NVMe
          pciutils          # Manage PCI | 'lspci'
          usbutils          # Manage USB | 'lsusb'
          vdpauinfo         # VDPAU
          vulkan-tools      # 'vulkaninfo'

          # Images
          feh               # Image viewer
          imagemagick       # Image tools

          # Monitoring
          htop              # Resource manager
          iptraf-ng         # Network
          pstree            # Process tree

          # Network
          #cifs-utils       # SMB support
          dig               # DNS tools
          ethtool           # Diagnostic / control
          ipcalc            # Network calculator
          mtr               # ping/traceroute
          nfs-utils         # NFS support
          nmap              # Discovery
          sipcalc           # Advanced network calculator
          speedtest-cli     # Bandwidth testing
          tcpdump           # Sniffer
          traceroute        # Route tracing
          whois             # Domain lookup

          # Nix
          nixfmt            # Officlal Nix formatter
          nix-tree          # Browse nix store
          nvd               # Package version diff tool

          # Notifications
          libnotify         # Notification engine

          # Productivity
          hunspell          # Spellcheck

          # Secrets
          sops              # Secret management
          ssh-to-age        # Convert SSH keys to Age

          # Terminal
          chafa             # Terminal images
          coreutils         # GNU utilities
          cryptsetup        # Encryption
          #devenv           # Declarative development environments
          dust              # Disk usage
          eza               # ls/tree replacement | 'eza' or 'exa'
          fastfetch         # Faster system info
          fd                # Find alternative | 'fd'
          killall           # Process killer
          ripgrep           # Search file contents | 'rg'
          shellcheck        # Script formating checker
          sysstat           # 'iostat' & various tools
          tldr              # Abbreviated manual
          tmux              # Multiplexor
          toybox            # Various commands
          wget              # Retriever
          wl-clipboard      # Enable wl-copy/wl-paste
          xdg-utils         # Environment integration
          zellij            # Tmux alternative

          # Theming
          #variety          # Wallpapers
          ;

        inherit (pkgs.hunspellDicts)
          en_US # US English for hunspell
          ;
      };

      variables = {
        BROWSER = config.flake.browser;
        EDITOR = "nvim";
        TERMINAL = config.flake.terminal;
      };
    };

    fonts = {
      fontconfig.useEmbeddedBitmaps = true;
      packages = builtins.attrValues {
        inherit (pkgs)
          iosvmata       # Term
          jetbrains-mono # Term
          pragmasevka    # Term
          noto-fonts-color-emoji # Emojis
          ;
        inherit (pkgs.nerd-fonts)
          symbols-only # Icons
          ;
      };
    };

    home-manager.users.${flk.user} =
      { osConfig, ... }:
      {
        imports = (import ./home);

        programs = {
          direnv = {
            enable = true; # `echo "use nix" >> .envrc && direnv allow`
            config = /* ~/.config/direnv/direnv.toml */ {
              global.hide_env_diff = true;
            };
            enableBashIntegration = true;
            nix-direnv.enable = true;
            silent = false;
            stdlib = /* ~/.config/direnv/direnvrc */ '''';
          };
          ssh = {
            enableDefaultConfig = false;
            matchBlocks."*" = {
              forwardAgent = false;
              addKeysToAgent = "no";
              compression = false;
              serverAliveInterval = 0;
              serverAliveCountMax = 3;
              hashKnownHosts = false;
              userKnownHostsFile = "~/.ssh/known_hosts";
              controlMaster = "no";
              controlPath = "~/.ssh/master-%r@%n:%p";
              controlPersist = "no";
            };
          };
        };
        # Auto shell rebuild upon .nix change
        services.lorri = {
          enable = true;
          enableNotifications = false;
          nixPackage = osConfig.nix.package;
        };
        xdg.userDirs.createDirectories = true;
      };

    i18n.defaultLocale = "en_US.UTF-8";

    networking.networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wifi.env".path ];
        profiles."home-wifi" = {
          connection = {
            id = "$home_ssid";
            type = "wifi";
          };
          ipv4.method = "auto";
          ipv6.method = "disabled";
          wifi = {
            mode = "infrastructure";
            ssid = "$home_ssid";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$home_psk";
          };
        };
      };
    };

    nix = {
      channel.enable = false;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      nixPath = [ "nixpkgs=/etc/nix/nixpkgs" ];
      optimise.automatic = true;
      registry = {
        devshells.to = {
          type = "github";
          owner = "j-pap";
          repo = "devshells";
        };
        nixpkgs.flake = inputs.nixpkgs;
        stable.flake = inputs.stable;
      };
      settings = {
        auto-optimise-store = true;
        download-buffer-size = 536870912; # 512MB in Bytes
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        extra-builtins-file = lib.mkIf (useNixPlugins) [ "${inputs.self}/libs/extra-builtins.nix" ];
        plugin-files = lib.mkIf (useNixPlugins) [ "${pkgs.nix-plugins}/lib/nix/plugins" ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://wezterm.cachix.org"
          "https://attic.xuyh0120.win/lantian" # xddxdd/nix-cachyos-kernel
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
        trusted-users = [ "@wheel" ];
      };
    };

    programs = {
      command-not-found.enable = true;
    };

    security = {
      polkit.enable = true;
      sudo = {
        extraConfig = ''Defaults lecture = never'';
        wheelNeedsPassword = true;
      };
      wrappers.btop = {
        enable = true;
        owner = "root";
        group = "root";
        source = "${lib.getExe config.home-manager.users.${flk.user}.programs.btop.package}";
        capabilities = "cap_perfmon=ep";
      };
    };

    services = {
      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [
          "/"
          "/home"
          "/nix"
        ];
      };
      fstrim.enable = lib.mkDefault true; # SSD trim
      fwupd.enable = true;
      geoclue2.enableDemoAgent = lib.mkForce true;
      localtimed.enable = true;
      openssh = {
        enable = true;
        extraConfig = "AllowAgentForwarding yes";
        knownHosts = {
          "FW13".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQQSTCKMqWNCTIFsND7Da2EUTjYktXX8xNl7Yf4X4At";
          "T1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiwqkVHyuJgJAdln6Wg7NXip2awN38aXddPydQhTw18";
          "T450s".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECb1ohJxet0NfaDOGRGEMVGkTY8sUZQ9t9h3P49g+nj";
        };
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          PubkeyAuthentication = "yes";
          UseDns = true;
        };
      };
    };

    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
      secrets = {
        "user/password".neededForUsers = true;
        "wifi.env" = { };
      };
      validateSopsFiles = false;
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;

    time.timeZone = lib.mkDefault "America/Chicago";

    users = {
      mutableUsers = false; # All users/passwords setup via declaration
      users = {
        ${flk.user} = {
          description = "Jason";
          extraGroups = [
            "adbusers"
            "input"
            "networkmanager"
            "video"
            "wheel"
          ]
          ++ lib.optionals (config.hardware.fancontrol.enable) [
            "fancontrol"
          ];
          hashedPasswordFile = config.sops.secrets."user/password".path;
          isNormalUser = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMoEb31xABf0fovDku5zBfBDI2sKCixc31wndQj5VhT ${flk.user}"
          ];
        };

        root.initialHashedPassword = "!"; # Disables root login
      };
    };
  };
}
