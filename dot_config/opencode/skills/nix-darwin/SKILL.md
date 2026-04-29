---
name: nix-darwin
description: Install packages and configure macOS via nix-darwin. Load this skill when the user wants to add a package, app, or change macOS settings.
---

## What nix-darwin is

nix-darwin manages macOS system configuration declaratively through Nix. The flake lives at `~/.config/wagounix`.

## Where to add a macOS package

Use this decision tree:

### CLI tool (available in nixpkgs)

1. Check if it exists: `nix search nixpkgs <name>`
2. Determine scope:
   - **All machines (macOS + NixOS)** → `hosts/common/packages.nix`
   - **All macOS machines only** → `hosts/darwin/packages.nix`
   - **All personal Macs** → `hosts/darwin/personal/packages.nix`
   - **All work Macs** → `hosts/darwin/work/packages.nix`
   - **One specific Mac** → `hosts/darwin/<layer>/<host>/packages.nix`
3. Add the package to `environment.systemPackages`

### GUI app (Homebrew cask)

1. Determine scope:
   - **All macOS machines** → `hosts/darwin/homebrew.nix` casks list
   - **All personal Macs** → `hosts/darwin/personal/homebrew.nix`
   - **All work Macs** → `hosts/darwin/work/homebrew.nix`
   - **One specific Mac** → `hosts/darwin/<layer>/<host>/homebrew.nix`
2. Add the cask name as a string to the `casks` list
3. If the app needs a custom install path: `{ name = "app"; args = { appdir = host.restrictedAppDir; }; }`

### Homebrew CLI formula (brew)

Same scope logic as casks, but add to the `brews` list instead.

### Mac App Store app

Add to `masApps` in the appropriate `homebrew.nix`:
```nix
masApps = {
  "App Name" = 123456789;  # Mac App Store ID
};
```

## Key commands

| Command | What it does |
|---|---|
| `darwin-rebuild switch --flake ~/.config/wagounix#<profile>` | Build and activate |
| `darwin-rebuild build --flake ~/.config/wagounix#<profile>` | Build without activating (test) |
| `nix search nixpkgs <name>` | Search for a nix package |
| `nix flake update` | Update all inputs to latest |

The `build` alias: `sudo darwin-rebuild switch --flake ~/.config/wagounix#<profile>`

## macOS profiles

| Profile | System | Description |
|---|---|---|
| `sap` | aarch64-darwin | SAP work Mac (legacy) |
| `wagoumac` | aarch64-darwin | New personal Mac |
| `alan` | aarch64-darwin | New work Mac (disabled, not in flake) |

## Important rules

- `onActivation.cleanup = "uninstall"` — removing a cask/brew from config WILL uninstall it
- `mutableTaps = false` — new Homebrew taps must be added as flake inputs
- GUI apps → Homebrew casks; CLI tools → nix packages (prefer nix when available)
- No home-manager — user dotfiles are managed by chezmoi separately
- Nix daemon is managed by Lix installer, not nix-darwin (`nix.enable = false`)
- Always `darwin-rebuild build` first to test, then `switch` to activate
- Load the `nix-config` repo skill when working inside `~/.config/wagounix` for full structural details
