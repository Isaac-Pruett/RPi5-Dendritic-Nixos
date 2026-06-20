# nixos-rpi

Hello-world NixOS for Raspberry Pi 5. Same host config, two delivery
methods: flash to an SD card, or deploy in place with `deploy-rs`.

## Why not stock `nixos-rebuild build-image`?

The new `nixos-rebuild build-image --image-variant sd-card` flow is the right path for Pi 4 and
other supported aarch64 boards (it replaced `nix-community/nixos-generators`, which is archived).
But nixpkgs's `sd-image-aarch64.nix` doesn't yet ship the Pi 5 firmware/U-Boot bits, so we use the
[nixos-raspberrypi] community flake instead — it provides Pi 5 kernel + firmware + an `sdImage`
attribute, plus a Cachix binary cache so the Pi-vendor `linux-rpi` kernel doesn't compile from
source on every build.

If/when nixpkgs gains a Pi 5 image variant, the migration is a one-line change: drop the community
flake and call `rpi.config.system.build.images.sd-card` instead.

[nixos-raspberrypi]: https://github.com/nvmd/nixos-raspberrypi

## Quickstart

```sh
nix flake update

# Build the SD-card image
just build-image            # = nix build .#sd-image -L --accept-flake-config

# Flash it (replace /dev/sdX)
just flash /dev/sdX

# After first boot, deploy new generations in place
just deploy                 # = deploy .#rpi
```

The `--accept-flake-config` flag lets the flake's `nixConfig` register
the `nixos-raspberrypi.cachix.org` substituter for this build. To
avoid the prompt globally, add the substituter+key to
`/etc/nix/nix.conf` (or `~/.config/nix/nix.conf`):

```
extra-substituters = https://nixos-raspberrypi.cachix.org
extra-trusted-public-keys = nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=
```

## Seeing what's happening during a build

`nix build` is silent by default. Three ways to fix that:

- `-L` (verbose logs): `nix build .#sd-image -L`
- `nix-output-monitor` (per-derivation progress tree, in the dev shell):
  `just build-image-nom`
- Tail a specific derivation's live log:
  `nix log -f /nix/store/<hash>-<name>.drv` (drv paths are printed in
  the "these N derivations will be built" header at the top of any
  `nix build` run). Wrap as `just log <drv>`.

The Pi-vendor kernel is parallel-built (`make -j$NIX_BUILD_CORES`)
when no cached closure exists. The Cachix substituter from
`nixos-raspberrypi` makes the kernel a download instead of a compile
in the common case.

## Cross-compiling

Building aarch64 on x86 needs binfmt qemu on the build host:

```nix
boot.binfmt.emulatedSystems = ["aarch64-linux"];
```

…or set `remoteBuild = true;` in `flake.nix` to build on the pi itself.

## Layout

- `flake.nix` — inputs, two flavours of the host (`rpi-installer` for
  flashing, `rpi` for deploy-rs), `sd-image` package
- `modules/rpi5.nix` — Pi 5 kernel/firmware (via `nixos-raspberrypi`)
- `modules/base.nix` — ssh, avahi, users, motd, hello pkg
- `modules/hardware.nix` — `fileSystems` for the on-disk system; only
  pulled in by `rpi`, since `rpi-installer` gets them from the
  sd-image module
