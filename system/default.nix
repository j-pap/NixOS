{
  config,
  lib,
  pkgs,
  ffVariant,
  inputs,
  myUser,
  ...
}:
{
  #imports = (import ./programs ++ import ../modules);
  imports = (import ../modules);

  options.flake.user = lib.mkOption {
    default = "jays";
    type = lib.types.str;
  };

  config = {
    _module.args = {
      browser = config.environment.variables.BROWSER;
      ffVariant = "firefox"; # firefox, floorp, or librewolf
      ffVersion = config.home-manager.users.${myUser}.programs.${ffVariant}.package.version;
      terminal = config.environment.variables.TERMINAL;
      nixSecrets =
        assert lib.assertMsg (builtins ? extraBuiltins.readSops)
          "The extraBuiltin 'readSops' could not be read. Verify that 'nix.settings.extra-builtins-file' is defined correctly.";
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
          clinfo            # OpenCL info | 'clinfo -l' or -a
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
          nixfmt-rfc-style  # Officlal Nix formatter
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
        BROWSER = lib.mkDefault "firefox";
        EDITOR = "nvim";
      };
    };

    fonts.packages = builtins.attrValues {
      inherit (pkgs)
        iosvmata       # Term
        jetbrains-mono # Term
        pragmasevka    # Term
        ;
      inherit (pkgs.nerd-fonts)
        symbols-only # Icons
        ;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    home-manager.users.${myUser} =
      { osConfig, ... }:
      {
        imports = (import ./home);

        programs = {
          # `echo "use nix" >> .envrc && direnv allow`
          direnv = {
            enable = true;
            config = { }; # ~/direnv/direnv.toml
            enableBashIntegration = true;
            nix-direnv.enable = true;
            silent = false;
            stdlib = ""; # ~/direnv/direnvrc
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
        extra-builtins-file = [ "${inputs.self}/libs/extra-builtins.nix" ];
        plugin-files = [ "${pkgs.nix-plugins}/lib/nix/plugins" ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://wezterm.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
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
        source = "${lib.getExe config.home-manager.users.${myUser}.programs.btop.package}";
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
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          tapping = true;
          tappingDragLock = true;
        };
      };
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
      udisks2 = {
        enable = true;
        mountOnMedia = true;
        #settings = { };
      };
      xserver = {
        excludePackages = [ pkgs.xterm ];
        xkb.layout = "us";
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
    time.timeZone = "America/Chicago";

    users = {
      mutableUsers = false; # All users/passwords setup via declaration
      users = {
        ${myUser} = {
          description = "Jason";
          extraGroups = [
            "adbusers"
            "input"
            "networkmanager"
            "video"
            "wheel"
          ];
          hashedPasswordFile = config.sops.secrets."user/password".path;
          isNormalUser = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMoEb31xABf0fovDku5zBfBDI2sKCixc31wndQj5VhT ${myUser}"
          ];
        };

        root.initialHashedPassword = "!"; # Disables root login
      };
    };
  };
}
