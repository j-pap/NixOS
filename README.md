# NixOS System(s) Flake

This is my flake for a multi-system NixOS installation. It's constantly being
updated and tweaked to be as efficient and secure as possible. The following is
a brief summary of the hosts:

* Framework 13 is running GNOME at the moment, because in my opinion, it
currently feels like the most integrated DE to embrace a laptop's features.
COSMIC may eventually replace GNOME once I've tested & configured it further.
* T1 (gaming desktop) is currently running KDE, but may eventually switch to
Hyprland once it's configured further.
* T450s is a spare laptop that I'm currently utilizing to test & configure
various desktop environments.

## Installation

The systems are entirely declarative, even using [disko](https://github.com/nix-community/disko)
to format & partition the drives before installing the OS. Be sure to
setup or remove [sops-nix](https://github.com/Mic92/sops-nix) prior to building
the system, or else you won't be able to login since the user password is stored
as a secret.

To deploy this flake, I've declared an ISO configuration which includes all the
necessary tools required. Once it's been built and booted, run the following
commands as root:

```
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

```
mkdir -p /mnt/etc/nixos && cd $_
git clone https://github.com/j-pap/NixOS.git /mnt/etc/nixos
git remote set-url origin git@github.com:j-pap/NixOS.git
nixos-install --no-root-passwd --flake .#<host>
```

## Directory Tree & Breakdown

```sh
nixos
├── base
│   ├── home
│   └── system
├── hosts
│   ├── FW13
│   ├── iso
│   ├── T1
│   ├── T450s
│   └── VM
├── libs
├── modules
│   ├── desktops
│   ├── hardware
│   ├── programs
│   └── host.nix
├── overlays
├── pkgs
│   └── fonts
├── secrets
├── flake.lock
└── flake.nix
```

#### Base

* ./default.nix is the base configuration applied to every host, unless
declared as a standalone system in flake.nix (fonts, programs/services, users,
etc). Libs and modules are imported from here.
* ./home: Default programs that are separated out, configured, and imported
through Home-Manager.
* ./system: Default programs that are separated out, configured, and imported
through NixOS.

#### Hosts

* Each host has its own directory with system-specific configuration files.
* ./iso: Defines a custom, bootable .iso file used for fresh OS installs.

#### Libs

Custom libraries/functions are declared & imported in ./default.nix, with each
function having its own separate file.

#### Modules

Each directory's default.nix imports the modules contained within that
directory. These utilize custom options to define and configure each system's
configuration.

* ./default.nix: Imports the directories and files below.
* ./desktops: Contain individual desktop environments and their dependencies.
  * COSMIC: Declared using [cosmic-manager](https://github.com/HeitorAugustoLN/cosmic-manager).
  * GNOME: Declared using home-manager's [dconf.settings](https://home-manager-options.extranix.com/?query=dconf.settings&release=master).
  * Hyprland: At a point where it's now usable, but I'll be updating/upgrading
  it more in the foreseeable future.
  * KDE Plasma: Declared using [plasma-manager](https://github.com/nix-community/plasma-manager).
* ./hardware: Hardware configurations that are potentially used across multiple
hosts (audio, bluetooth, GPUs, etc).
* ./programs: Configured applications that can easily be enabled/disabled.
* ./host.nix: Declares host options, which are then individually configured per
system (monitor, themes, wallpapers, etc).

#### Overlays

Modify existing and/or add Nix packages. Imported through flake.nix.

#### Pkgs

Programs packaged for Nix and made available through overlays.

#### Secrets

Self-explanatory.
