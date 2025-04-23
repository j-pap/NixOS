{
  config,
  lib,
  pkgs,
  cfgOpts,
  cfgTerm,
  inputs,
  myUser,
  nixPath,
  ...
}: let
  iosvmata = pkgs.callPackage ../pkgs/fonts/iosvmata.nix { };
  pragmasevka = pkgs.callPackage ../pkgs/fonts/pragmasevka.nix { };
  userName = "Jason";
in {
  imports = (
    import ./programs ++ 
    import ../modules
  );

  options.myUser = lib.mkOption {
    default = "jays";
    type = lib.types.str;
  };

  config = {
    myOptions.${cfgTerm}.enable = true;

    boot = {
      # Prioritize swap for hibernation only
      kernel.sysctl."vm.swappiness" = lib.mkDefault 0;
      # Clear /tmp on every boot
      tmp.cleanOnBoot = true;
    };

    console = {
      #font = "Lat2-Terminus16";
      keyMap = "us";
    };

    environment = {
      # Symlink for nix.nixPath
      etc."nix/nixpkgs".source = "${pkgs.path}";

      # List packages installed in system profile. To search, run:
        # $ nix search wget
      # To use a stable version, add 'stable.' to the beginning of the package:
        # pkgs.stable.wget
      systemPackages = builtins.attrValues {
        inherit (pkgs)
        # ASCII Art
          asciiquarium          # Fishies swimming
          cbonsai               # Bonsai growing

        # Files
          cryptomator           # Encrypt cloud files
          exiftool              # File metadata
          file                  # File information
          libarchive            # ISO extraction | 'bsdtar -xf IsoFile.iso OutputFile'
          p7zip                 # Zip encryption
          unzip                 # Zip files
          unrar                 # Rar files
          zip                   # Zip files

        # Hardware
          clinfo                # OpenCL info | 'clinfo -l' or -a
          dmidecode             # Firmware | 'dmidecode -s bios-version'
          ffmpeg-full           # Hardware video acceleration
          glxinfo               # OpenGL info
          lm_sensors            # Hardware sensors | 'sensors-detect'
          lshw                  # Hardware config
          nvme-cli              # Manage NVMe
          pciutils              # Manage PCI | 'lspci'
          usbutils              # Manage USB | 'lsusb'

        # Images
          feh                   # Image viewer
          imagemagick           # Image tools

        # Monitoring
          htop                  # Resource manager
          pstree                # Process tree

        # Network
          #cifs-utils           # SMB support
          dig                   # DNS tools
          nfs-utils             # NFS support
          nmap                  # Network discovery

        # Nix
          nixfmt-rfc-style      # Officlal Nix formatter
          nix-tree              # Browse nix store

        # Notifications
          libnotify             # Notification engine

        # Productivity
          hunspell              # Spellcheck

        # Secrets
          sops                  # Secret management
          ssh-to-age            # Convert SSH keys to Age

        # Terminal
          chafa                 # Terminal images
          coreutils             # GNU utilities
          cryptsetup            # Encryption
          dust                  # Disk usage
          eza                   # ls/tree replacement | 'eza' or 'exa'
          fastfetch             # Faster system info
          fd                    # Find alternative | 'fd'
          killall               # Process killer
          ripgrep               # Search file contents | 'rg'
          shellcheck            # Script formating checker
          tldr                  # Abbreviated manual
          tmux                  # Multiplexor
          toybox                # Various commands
          tree                  # Directory layout
          wget                  # Retriever
          wl-clipboard          # Enable wl-copy/wl-paste
          xdg-utils             # Environment integration
          zellij                # Tmux alternative

        # Theming
          #variety              # Wallpapers
        ;

        inherit (pkgs.hunspellDicts)
          en_US                 # US English for hunspell
        ;
      };

      variables = {
        BROWSER = cfgOpts.browser;
        EDITOR = "nvim";
        TERMINAL = cfgTerm;
      };
    };

    fonts.packages = builtins.attrValues {
      inherit (pkgs)
        cantarell-fonts         # GNOME
        #iosevka                 # Term
        jetbrains-mono          # Term
        #monoid                  # Term
        noto-fonts              # KDE
      ;
      inherit (pkgs.nerd-fonts)
        symbols-only            # Icons
      ;
    } ++ [
      iosvmata                  # Term
      pragmasevka               # Term
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    home-manager.users.${myUser} = {
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
      package = pkgs.nixVersions.nix_2_24;
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        stable.flake = inputs.nixpkgs-stable;
      };
      settings = {
        auto-optimise-store = true;
        download-buffer-size = 536870912; # 512MB in Bytes
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        extra-builtins-file = "${nixPath}/libs/extra-builtins.nix";
        plugin-files = [ "${pkgs.nix-plugins}/lib/nix/plugins" ];
        substituters = [
          "https://cosmic.cachix.org/"
          "https://nix-community.cachix.org"
          "https://wezterm.cachix.org"
        ];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
        ];
        trusted-users = [ "@wheel" ];
      };
    };

    programs = {
      dconf.enable = true;
      /*
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };*/
    };

    security = {
      polkit.enable = true;
      sudo = {
        extraConfig = ''Defaults lecture = never'';
        wheelNeedsPassword = true;
      };
    };

    services = {
      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" "/home" "/nix" ];
      };
      # SSD trim
      fstrim.enable = lib.mkDefault true;
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
          "FW13".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQQSTCKMqWNCTIFsND7Da2EUTjYktXX8xNl7Yf4X4At";
          "T1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiwqkVHyuJgJAdln6Wg7NXip2awN38aXddPydQhTw18";
          "T450s".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECb1ohJxet0NfaDOGRGEMVGkTY8sUZQ9t9h3P49g+nj";
        };
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          PubkeyAuthentication = "yes";
          UseDns = true;
        };
      };
      xserver = {
        excludePackages = [ pkgs.xterm ];
        xkb.layout = "us";
      };
    };

    sops = {
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      defaultSopsFile = "${nixPath}/secrets/secrets.yaml";
      secrets = {
        "user/password".neededForUsers = true;
        "wifi.env" = { };
      };
      validateSopsFiles = false;
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;
    time.timeZone = "America/Chicago";

    users = {
      # All users/passwords setup via declaration
      mutableUsers = false;
      users = {
        ${myUser} = {
          description = userName;
          extraGroups = [
            "adbusers"
            "audio"
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

        # Disables root login
        root.initialHashedPassword = "!";
      };
    };
  };
}
