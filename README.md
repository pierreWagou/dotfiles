<div align="center">

![header](https://capsule-render.vercel.app/api?type=waving&height=220&color=0:cba6f7,25:b4befe,50:89dceb,75:f5c2e7,100:f38ba8&text=dotfiles&fontSize=60&fontColor=11111b&desc=~/%20sweet%20~/&descSize=18&descAlignY=62&descAlign=50&fontAlignY=38&animation=fadeIn&fontAlign=50)

![Chezmoi](https://img.shields.io/badge/Chezmoi-Managed-ff6ec7?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTEyIDJMMiA3djEwbDEwIDUgMTAtNVY3TDEyIDJ6IiBmaWxsPSJ3aGl0ZSIvPjwvc3ZnPg==&logoColor=white)
![Nix](https://img.shields.io/badge/Nix-Darwin-5277C3?logo=nixos&logoColor=white)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-e0b0ff?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PGNpcmNsZSBjeD0iMTIiIGN5PSIxMiIgcj0iMTAiIGZpbGw9IndoaXRlIi8+PC9zdmc+&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-aarch64%20%7C%20x86__64-302b63?logo=apple&logoColor=white)
![NixOS](https://img.shields.io/badge/NixOS-x86__64-5277C3?logo=nixos&logoColor=white)

</div>

---

Personal macOS and NixOS configuration managed with [chezmoi](https://chezmoi.io/), themed with **Catppuccin Mocha**, provisioned with **Nix Darwin** and **NixOS**.

- Terminal-first workflow -- Ghostty, tmux, Neovim, zsh
- Four Nix profiles -- `sap` (work), `alan` (work), `wagoumac` (personal), `wagoulab` (NixOS)
- Secrets injected at apply-time via rbw (Bitwarden/Vaultwarden CLI) -- zero credentials in the repo
- 27+ tools configured and version-controlled

## Architecture

```
 ┌──────────────────────────────────────────────────────┐
 │                    chezmoi                           │
 │              (dotfile orchestrator)                  │
 ├────────────────────────┬─────────────────────────────┤
 │     Nix Darwin         │        rbw CLI          │  provisioning
 │  (packages + system)   │   (secrets via templates)   │
 ├──────┬────────┬────────┼──────┬──────────┬───────────┤
 │Shell │Terminal│ Editor │  Dev │    AI    │   Media   │  tools
 │ zsh  │ghostty │ nvim   │  git │  claude  │ spicetify │
 │      │ tmux   │        │  fzf │ opencode │ sp-player │
 │      │ sesh   │        │  bat │   hai    │           │
 │      │        │        │ mise │          │           │
 └──────┴────────┴────────┴──────┴──────────┴───────────┘
```

## Structure

```
~/.local/share/chezmoi/
├── dot_config/
│   ├── nvim/           neovim (lazyvim)
│   ├── zsh/            shell config + plugins
│   ├── tmux/           multiplexer
│   ├── ghostty/        terminal emulator
│   ├── git/            version control
│   ├── starship/       prompt
│   └── ...             27 tools total
├── private_dot_ssh/            known hosts
├── dot_zshenv          ZDOTDIR bootstrap
└── .chezmoi.toml.tmpl  profile selector
```

<details>
<summary>Full directory tree</summary>

```
dot_config/
├── bat/            cat replacement
├── bottom/         system monitor
├── claude/         claude code settings
├── copilot/        github copilot cli
├── databricks/     workspace tokens
├── docker/         docker desktop
├── eza/            ls replacement, file colors
├── fsh/            fast syntax highlighting
├── fzf/            fuzzy finder
├── gh/             github cli (dual host)
├── ghostty/        terminal emulator
├── git/            conditional sap profile, delta
├── hai/            sap hyperspace ai
├── nvim/           neovim (lazyvim distro)
├── opencode/       opencode ai assistant
├── private_gnupg/  gpg keys + agent
├── sesh/           session manager
├── sheldon/        zsh plugin manager
├── spicetify/      spotify theming
├── spotify-player/ spotify tui
├── starship/       cross-shell prompt
├── television/     fuzzy picker
├── tmux/           terminal multiplexer
├── tmuxinator/     session layouts
├── worktrunk/      git worktree manager
└── zsh/            shell configuration
```

</details>

## Getting Started

**Prerequisite** -- chezmoi installed via the [wagounix](https://github.com/pierreWagou/wagounix) Nix flake.

```bash
chezmoi init --apply pierreWagou
```

You will be prompted to select a Nix profile (`sap`, `alan`, `wagoumac`, or `wagoulab`).

## Shell

> [`dot_config/zsh/dot_zshrc.tmpl`](dot_config/zsh/dot_zshrc.tmpl) -- Zsh with ZDOTDIR relocated to `~/.config/zsh`

| Category | Tool | Description |
|----------|------|-------------|
| Plugin manager | [Sheldon](https://sheldon.cli.rs/) | zsh-completions, fzf-tab, autosuggestions, fast-syntax-highlighting, you-should-use |
| Prompt | [Starship](https://starship.rs/) | Cross-shell, minimal, configurable |
| Navigation | [Zoxide](https://github.com/ajeetdsouza/zoxide) / [fzf](https://github.com/junegunn/fzf) | Smart cd + fuzzy finder |
| Aliases | [eza](https://eza.rocks/) | ls replacement, plus git/system shortcuts |
| Node | [fnm](https://github.com/Schniz/fnm) | Fast Node Manager |

## Terminal

| Tool | Config | Notes |
|------|--------|-------|
| [Ghostty](https://ghostty.org/) | [`ghostty/config`](dot_config/ghostty/config) | JetBrainsMono Nerd Font |
| [Tmux](https://github.com/tmux/tmux) | [`tmux/tmux.conf`](dot_config/tmux/tmux.conf) | Prefix `C-Space`, vim-tmux-navigator, TPM |
| [Tmuxinator](https://github.com/tmuxinator/tmuxinator) | [`tmuxinator/`](dot_config/tmuxinator/) | `workspace` layout -- nvim + opencode + terminal |
| [Sesh](https://github.com/joshmedeski/sesh) | [`sesh/`](dot_config/sesh/) | Session manager |

## Editor

> [`dot_config/nvim/`](dot_config/nvim/) -- Neovim with [LazyVim](https://www.lazyvim.org/)

| Area | Details |
|------|---------|
| Languages | Java, Python, TypeScript, JSON, YAML, TOML, Markdown, SAP CDS |
| Jupyter | Molten (inline output), jupytext (percent scripts), image.nvim |
| Navigation | Telescope, Harpoon2, Aerial |
| Debugging | DAP |
| Completion | Blink, Copilot |
| Editing | mini-comment, mini-surround, inc-rename, yanky |
| Integration | vim-tmux-navigator, venv-selector |
| UI | Dashboard, indent-blankline, treesitter-context, lualine |

## Dev Tools

| Tool | Config | Notes |
|------|--------|-------|
| [Git](https://git-scm.com/) | [`git/`](dot_config/git/) | Conditional SAP profile, Delta pager |
| [fzf](https://github.com/junegunn/fzf) | [`fzf/config`](dot_config/fzf/config) | Fuzzy finder |
| [Bat](https://github.com/sharkdp/bat) | [`bat/config`](dot_config/bat/config) | Syntax-highlighted `cat` |
| [Starship](https://starship.rs/) | [`starship/starship.toml`](dot_config/starship/starship.toml) | Cross-shell prompt |
| [eza](https://eza.rocks/) | [`eza/theme.yml`](dot_config/eza/theme.yml) | File type colors |
| [Bottom](https://github.com/ClementTsang/bottom) | [`bottom/`](dot_config/bottom/) | System monitor |
| [GitHub CLI](https://cli.github.com/) | [`gh/`](dot_config/gh/) | Dual host config |
| [Docker](https://www.docker.com/) | [`docker/`](dot_config/docker/) | Docker Desktop |
| [Television](https://github.com/alexpasmantier/television) | [`television/`](dot_config/television/) | Fuzzy picker |
| [Mise](https://mise.jdx.dev/) | [`mise/config.toml`](dot_config/mise/config.toml) | Polyglot tool manager |
| [Worktrunk](https://github.com/nicholasgasior/worktrunk) | [`worktrunk/`](dot_config/worktrunk/) | Git worktree manager |

## AI

| Tool | Config | Notes |
|------|--------|-------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | [`claude/settings.json.tmpl`](dot_config/claude/settings.json.tmpl) | Anthropic CLI |
| [OpenCode](https://opencode.ai/) | [`opencode/opencode.json.tmpl`](dot_config/opencode/opencode.json.tmpl) | Claude via local proxy, MCP servers, skills |
| [Copilot CLI](https://docs.github.com/en/copilot) | [`copilot/`](dot_config/copilot/) | GitHub Copilot |
| [HAI](https://www.sap.com/) | [`hai/config.yaml`](dot_config/hai/config.yaml) | SAP Hyperspace AI |

## Media & Email

| Tool | Config | Notes |
|------|--------|-------|
| [Spicetify](https://spicetify.app/) | [`spicetify/`](dot_config/spicetify/) | Spotify desktop theming |
| [spotify-player](https://github.com/aome510/spotify-player) | [`spotify-player/`](dot_config/spotify-player/) | Spotify TUI |

## Cloud & Security

| Tool | Config | Notes |
|------|--------|-------|
| [Databricks](https://www.databricks.com/) | [`databricks/databrickscfg.tmpl`](dot_config/databricks/databrickscfg.tmpl) | Test + prod workspaces |
| SSH | [`private_dot_ssh/`](private_dot_ssh/) | Known hosts |
| GPG | [`private_gnupg/`](dot_config/private_gnupg/) | gpg-agent with SSH + pinentry-mac, dual keys |

## Secrets

Files ending in `.tmpl` use [rbw](https://github.com/doy/rbw) (unofficial Bitwarden CLI) to inject secrets at apply time via chezmoi's `rbw` template function. **No credentials are stored in this repository.**

Templated secrets include:

- Anthropic API token (Claude Code, OpenCode)
- Databricks tokens (test + prod workspaces)

## Quick Reference

| Action | Command |
|--------|---------|
| Bootstrap | `chezmoi init --apply pierreWagou` |
| Apply changes | `chezmoi apply` |
| Edit a dotfile | `chezmoi edit ~/.config/<tool>/<file>` |
| See pending diff | `chezmoi diff` |
| Pull + apply | `chezmoi update` |
| Add a new file | `chezmoi add ~/.config/<tool>/<file>` |
