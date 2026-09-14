---
name: nix-system
description: NixOS/Nix system management, flake updates, and system configuration.
---

# nix-system — Nix management

This skill provides guidance for managing Nix-based systems.

## Environment

- **Nix flake location**: `~/Projects/wagou/wagounix`
- **Important**: Always apply system changes through the flake, not manually

## Usage

Use this skill when:
- Updating system packages
- Modifying system configuration
- Debugging NixOS issues
- Managing flake inputs

## Common Operations

### Update System
```bash
# From the wagounix directory
nix flake update
sudo nixos-rebuild switch --flake .
```

### Check System Status
```bash
nixos-rebuild list-generations
```

### Debug Configuration
```bash
# Check for configuration errors
nix build .#nixosConfigurations.host.config.system.build.toplevel --dry-run
```

## Best Practices

1. **Never edit `/etc/nixos/` directly** — always use the flake
2. **Test before switching** — use `--dry-run` or `nix build` first
3. **Commit changes** — track configuration in git
4. **Use flakes** — pin versions for reproducibility

## Flake Structure

```
~/Projects/wagou/wagounix/
├── flake.nix          # Main flake definition
├── flake.lock         # Pinned inputs
├── hosts/             # Host-specific configs
├── modules/           # Reusable modules
└── pkgs/              # Custom packages
```
