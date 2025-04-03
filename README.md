# NixOS System(s) Flake

This is my flake for a multi-system NixOS installation. I've tried to craft it
to be as secure as possible without being a complete inconvenience to the
average user. I currently run GNOME on my Framework because I feel like it is
the most integrated way of fully utilizing the system's features; This means declaring
nearly all options via dconf.settings to achieve reproducibility. I'm testing the
COSMIC desktop via the nixos-cosmic flake on my T450s, and may eventually
deploy it on my Framework, as well as my gaming system. Speaking of, my
gaming system uses KDE, provided by the plasma-manager flake. I also have a
half-baked Hyprland configuration, that I haven't gotten around to completing.

## Installation

The system's are entirely declarative, even using [disko](https://github.com/nix-community/disko)
to format & partition the drives before installing the OS. Be sure to
setup/remove [sops-nix](https://github.com/Mic92/sops-nix) prior to building
the system, or else you won't be able to login, as the user password is stored
as a secret.

To deploy this flake, I'm booting from an .iso I build using hosts/iso, which
includes the tools I need, and running these commands as root:

```sh
nix run github:nix-community/disko -- --mode disko --flake github:j-pap/NixOS#<host>
mkdir -p /mnt/etc/ssh
ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -C "root@<host>"
ssh-to-age -i /mnt/etc/ssh/ssh_host_ed25519_key.pub
```

* If this is an additional system being deployed:
  * From an existing, established sops system, add the newly generated age
    key to .sops.yaml, run `sops updatekeys secrets/secrets.yaml`, commit those
    files, and then run the commands in the code block below:
* If this is the first time sops is being setup:
  * .sops.yaml and secrets/secrets.yaml will need to be initialized after
    cloning the repo - refer to
    [sops-nix's instructions](https://github.com/Mic92/sops-nix?tab=readme-ov-file#usage-example)
    before running the commands in the code block below:

```sh
mkdir -p /mnt/etc/nixos && cd $_
git clone https://github.com/j-pap/NixOS.git /mnt/etc/nixos
git remote set-url origin git@github.com:j-pap/NixOS.git
nixos-install --no-root-passwd --flake .#<host>
```

## Breakdown

```sh
nixos
├── assets
├── common
│   └── programs
├── hosts
├── libs
├── modules
│   ├── desktops
│   ├── hardware
│   └── programs
├── pkgs
└── secrets
```

### Common

* default.nix is the base system configuration that is imported with each
system, alongside their system-specific config(s). Base programs, fonts, nix settings,
users, etc are setup here.
* /programs: contain additional programs that are included by default, that
are not modules, but are separated out for easier management.

### Hosts

* Each host/system has its own directory with its independent configuration file(s)
inside of it.
* The iso directory is used to define & build a custom, bootable .iso file
used for fresh installs.

### Modules

This is where all modules imported via /common/default.nix are managed. Each directory
has a default.nix that imports the individual modules. You'll notice that these utilize
custom options to easily enable them with boolean values in the system configurations.

* default.nix: imports the three directories below.
* /desktops: contain the individual desktop environments and their requirements
(Cosmic/GNOME/Hyprland/KDE).
* /hardware: contain the configs to enable individual hardware on systems
(audio, bluetooth, GPUs, etc).
* /programs: contain applications that can be enabled/disabled, usually
via the host configs.
