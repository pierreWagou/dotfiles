---
name: nix-darwin
description: Manage macOS system configuration with nix-darwin flakes - modules, packages, Homebrew, settings, and multi-host profiles
---

## What nix-darwin is

nix-darwin is a Nix-based system configuration tool for macOS, analogous to NixOS for Linux. It manages system packages, macOS defaults, services, Homebrew, and more through declarative Nix modules. This setup uses a **flake-based** configuration.

## Repository layout

The flake lives at `~/.config/wagounix` and follows this structure:

```
wagounix/
├── flake.nix              # Entrypoint: inputs and darwinConfigurations
├── flake.lock             # Pinned dependency versions
├── configuration.nix      # Core system config (nix settings, users, PAM)
├── packages.nix           # Shared nix packages and fonts
├── homebrew.nix           # Shared Homebrew brews, casks, masApps
├── icons.nix              # Custom macOS app icons
├── icons/                 # .icns icon files
├── settings/              # macOS system defaults (one module per category)
│   ├── default.nix        # Imports all settings modules
│   ├── dock.nix
│   ├── finder.nix
│   ├── keyboard.nix
│   └── ...                # control-center, global-domain, trackpad, etc.
└── hosts/                 # Per-host configurations
    ├── sap/               # Work machine (aarch64-darwin)
    │   ├── default.nix    # Imports host-specific sub-modules
    │   ├── variables.nix  # Host variables (username, paths, rosetta)
    │   ├── packages.nix   # Extra packages for this host
    │   └── homebrew.nix   # Extra homebrew config for this host
    └── wagou/             # Personal machine (x86_64-darwin)
        ├── default.nix    # Empty imports (no extras)
        └── variables.nix  # Host variables
```

## How the flake is wired

### Inputs

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  nix-darwin.url = "github:nix-darwin/nix-darwin/master";
  nix-darwin.inputs.nixpkgs.follows = "nixpkgs";  # share the same nixpkgs
  darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
  nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  # Homebrew taps pinned as non-flake inputs
  homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
  homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
  # Additional taps as needed...
};
```

### Outputs

Two `darwinConfigurations` -- one per host. Both share the same base modules but each gets its own `host` variables via `specialArgs`:

```nix
darwinConfigurations.<hostname> = nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";  # or "x86_64-darwin"
  modules = [
    ./configuration.nix
    ./packages.nix
    ./homebrew.nix
    ./icons.nix
    ./hosts/<hostname>
  ];
  specialArgs = {
    inherit inputs;
    host = import ./hosts/<hostname>/variables.nix;
  };
};
```

### Host variables pattern

Each host has a `variables.nix` that exports a plain attribute set (not a module):

```nix
rec {
  username = "I544489";
  restricted_app_root = "/Users/${username}";
  restricted_app_dir = "${restricted_app_root}/Applications";
  enableRosetta = true;
}
```

These are passed via `specialArgs` and available in all modules as `{ host, ... }:`.

## Writing nix-darwin modules

### Module structure

Every `.nix` file in the modules list is a function that receives module arguments:

```nix
{ pkgs, lib, config, host, inputs, ... }:
{
  # configuration options here
}
```

- `pkgs` -- the nixpkgs package set
- `lib` -- nixpkgs library functions
- `config` -- the fully evaluated configuration (for cross-referencing)
- `host` -- custom host variables (from `specialArgs`)
- `inputs` -- flake inputs (from `specialArgs`)

### Adding system packages

Edit `packages.nix` for shared packages:

```nix
{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git neovim tmux
  ];
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
}
```

For host-specific packages, edit `hosts/<hostname>/packages.nix`:

```nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    opencode
  ];
}
```

Nix-darwin **merges lists** from all modules automatically -- host-specific packages are added to (not replace) shared packages.

### Adding Homebrew packages

The `homebrew.nix` module uses `nix-homebrew` for declarative Homebrew management:

```nix
homebrew = {
  enable = true;
  onActivation = {
    upgrade = true;
    cleanup = "uninstall";  # removes anything not declared
  };
  brews = [ "dashlane-cli" ];
  casks = [
    "ghostty"
    { name = "discord"; args = { appdir = host.restricted_app_dir; }; }
  ];
  masApps = {
    "Xcode" = 497799835;  # Mac App Store ID
  };
};
```

Key options:
- `brews` -- CLI packages from Homebrew
- `casks` -- GUI applications from Homebrew Cask
- `masApps` -- Mac App Store apps (name = store ID)
- `onActivation.cleanup = "uninstall"` -- removes casks/brews not in the config
- `greedyCasks = true` -- always upgrades casks to latest
- Casks can take an `args` attribute for custom install paths

Homebrew taps are pinned as flake inputs with `flake = false` and `mutableTaps = false` for reproducibility.

### Adding macOS settings

Settings live under `settings/` as individual modules. Each maps to `system.defaults`:

```nix
# settings/dock.nix
{ ... }:
{
  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    persistent-apps = [
      "/Applications/Ghostty.app"
      "/Applications/Zen.app"
    ];
  };
}
```

To add a new settings module:
1. Create `settings/<category>.nix`
2. Add it to the imports list in `settings/default.nix`

Common `system.defaults` namespaces:
- `system.defaults.dock` -- Dock behavior
- `system.defaults.finder` -- Finder preferences
- `system.defaults.NSGlobalDomain` -- Global preferences (dark mode, key repeat, etc.)
- `system.defaults.trackpad` -- Trackpad gestures
- `system.defaults.".GlobalPreferences"` -- Additional global prefs
- `system.defaults.CustomUserPreferences` -- Arbitrary defaults domains
- `system.defaults.menuExtraClock` -- Menu bar clock
- `system.defaults.screencapture` -- Screenshot settings
- `system.defaults.screensaver` -- Screen saver settings
- `system.defaults.spaces` -- Mission Control spaces

### Adding a new host

1. Create `hosts/<hostname>/variables.nix` with the host's identity:
   ```nix
   rec {
     username = "myuser";
     restricted_app_root = "/Users/${username}";
     restricted_app_dir = "${restricted_app_root}/Applications";
     enableRosetta = false;
   }
   ```
2. Create `hosts/<hostname>/default.nix`:
   ```nix
   { ... }: { imports = []; }
   ```
3. Add a `darwinConfigurations.<hostname>` entry in `flake.nix`

### Custom app icons

Uses the `nix-darwin-custom-icons` module:

```nix
environment.customIcons = {
  enable = true;
  icons = [
    { path = "/Applications/Ghostty.app"; icon = ./icons/ghostty.icns; }
  ];
};
```

Place `.icns` files in the `icons/` directory.

## Key commands

| Command | What it does |
|---|---|
| `darwin-rebuild switch --flake ~/.config/wagounix#<host>` | Build and activate the configuration |
| `darwin-rebuild build --flake ~/.config/wagounix#<host>` | Build without activating (test build) |
| `darwin-rebuild check --flake ~/.config/wagounix#<host>` | Check the configuration for errors |
| `nix flake update` | Update all flake inputs to latest |
| `nix flake update <input>` | Update a single input |
| `nix flake lock --update-input <input>` | Same as above (older syntax) |
| `nix flake show` | Show flake outputs |
| `nix flake metadata` | Show flake inputs and their revisions |

The `build` alias in the shell is: `sudo darwin-rebuild switch --flake ~/.config/wagounix#<profile>`

## Nix language essentials

### Common patterns used

```nix
# Attribute set
{ key = "value"; nested = { a = 1; }; }

# List
[ "one" "two" "three" ]

# with expression (bring attrs into scope)
environment.systemPackages = with pkgs; [ git vim tmux ];

# String interpolation
home = "/Users/${host.username}";

# rec -- self-referencing attrset
rec { username = "me"; home = "/Users/${username}"; }

# Import
host = import ./hosts/sap/variables.nix;

# inherit -- shorthand for x = x
specialArgs = { inherit inputs; };  # equivalent to: inputs = inputs;

# Function with destructured attrset argument
{ pkgs, lib, ... }:   # ... accepts extra attrs
{
  # module body
}
```

### Module system

- Modules are functions that return attribute sets of **option values**
- Multiple modules setting the same **list** option are **merged** (e.g., `environment.systemPackages`)
- Multiple modules setting the same **scalar** option will **conflict** (last wins or error)
- Use `lib.mkForce` to override, `lib.mkDefault` to set a low-priority default
- Use `lib.mkIf <condition> { ... }` for conditional configuration

## Important rules when editing this flake

- ALWAYS work in `~/.config/wagounix/` -- this is the source of truth
- After editing, rebuild with `darwin-rebuild switch --flake ~/.config/wagounix#<host>` (or the `build` alias)
- Use `darwin-rebuild build` (without `switch`) first to test changes safely
- When adding a package, first check if it exists in nixpkgs: `nix search nixpkgs <name>`
- GUI apps generally go in `homebrew.nix` as casks; CLI tools go in `packages.nix` as nix packages
- Host-specific additions go in `hosts/<hostname>/` -- never add host-specific config to shared modules
- Homebrew `onActivation.cleanup = "uninstall"` means removing a cask/brew from the config WILL uninstall it
- `mutableTaps = false` means taps are pinned -- add new taps as flake inputs
- Run `nix flake update` to get the latest packages, then rebuild
- Commit and push changes to the git repo after successful rebuilds
- No home-manager is used -- user dotfiles are managed by chezmoi separately
- Nix daemon is managed externally (Lix installer), not by nix-darwin (`nix.enable = false`)
