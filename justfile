alias b := build-image-nom


_list:
    @just --list --unsorted

# Build a flashable SD-card image with verbose per-derivation logs.
build-image:
    nix build .#sd-image -L --accept-flake-config

# Same, piped through nix-output-monitor for a per-derivation progress tree.
build-image-nom:
    nix build .#sd-image -L --accept-flake-config --log-format internal-json |& nom --json

# Tail the live build log of a specific derivation. Find drv paths from `nix build`'s "these N derivations will be built" header.
log DRV:
    nix log -f {{ DRV }}

# Decompress and dd onto an SD card. Example: just flash /dev/sdX
flash DEVICE:
    zstd --decompress --stdout result/sd-image/*.img.zst \
      | sudo dd of='{{ DEVICE }}' bs=4M status=progress oflag=dsync conv=fsync
    sync

# Deploy a new generation to a running pi.
deploy:
    deploy .#rpi

# Same, but override the hostname (e.g. just deploy-to 192.168.1.42).
deploy-to TARGET:
    deploy .#rpi --hostname {{ TARGET }}

# Plain nixos-rebuild as a fallback to deploy-rs.
rebuild HOST='root@rpi.local':
    nixos-rebuild switch -L --target-host {{ HOST }} --flake .#rpi

check:
    nix flake check
