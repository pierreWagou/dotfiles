# Dotfiles

> Personal macOS configuration managed with [chezmoi](https://chezmoi.io/), themed with **Catppuccin Mocha** across the board.

---

## Quick Start

**Prerequisite** -- chezmoi installed via the [wagounix flake](https://github.com/pierreWagou/wagounix)

```bash
chezmoi init --apply pierreWagou
```

You will be prompted to select a nix profile (`sap` or `wagou`).

---

## What's Inside

### Shell

> [`dot_config/zsh/dot_zshrc.tmpl`](dot_config/zsh/dot_zshrc.tmpl) -- Zsh with ZDOTDIR relocated to `~/.config/zsh`

| Category | Tool |
|---|---|
| Plugin manager | [Sheldon](https://sheldon.cli.rs/) -- zsh-completions, fzf-tab, zsh-autosuggestions, fast-syntax-highlighting, you-should-use |
| Prompt | [Starship](https://starship.rs/) |
| Navigation | [Zoxide](https://github.com/ajeetdsouza/zoxide) (cd replacement), [fzf](https://github.com/junegunn/fzf) |
| Aliases | [eza](https://eza.rocks/) (ls), git shortcuts, system commands (`update`, `build`, `vpn`) |
| Node | [fnm](https://github.com/Schniz/fnm) (Fast Node Manager) |

### Terminal

| Tool | Config | Notes |
|---|---|---|
| Ghostty | [`ghostty/config`](dot_config/ghostty/config) | JetBrainsMono Nerd Font |
| Tmux | [`tmux/tmux.conf`](dot_config/tmux/tmux.conf) | Prefix `C-Space`, vim-tmux-navigator, TPM |
| Tmuxinator | [`tmuxinator/`](dot_config/tmuxinator/) | `dev` layout -- nvim + opencode + terminal |
| Sesh | [`sesh/`](dot_config/sesh/) | Session manager |

### Editor

> [`dot_config/nvim/`](dot_config/nvim/) -- Neovim (LazyVim distribution)

| Area | Details |
|---|---|
| Languages | Java, Python, TypeScript, JSON, YAML, TOML, Markdown, SAP CDS |
| Jupyter | Molten (inline output), jupytext (percent scripts), image.nvim |
| Navigation | Telescope, Harpoon2, Aerial |
| Debugging | DAP |
| Completion | Blink completions, Copilot |
| Editing | mini-comment, mini-surround, inc-rename, yanky |
| Integration | vim-tmux-navigator, venv-selector |
| UI | Dashboard, indent-blankline, treesitter-context, lualine |

### Dev Tools

| Tool | Config | Notes |
|---|---|---|
| Git | [`git/`](dot_config/git/) | Conditional SAP profile, Delta pager |
| fzf | [`fzf/config`](dot_config/fzf/config) | Fuzzy finder |
| Bat | [`bat/config`](dot_config/bat/config) | `cat` replacement |
| Starship | [`starship/starship.toml`](dot_config/starship/starship.toml) | Cross-shell prompt |
| eza | [`eza/theme.yml`](dot_config/eza/theme.yml) | File type colors |
| Bottom | [`bottom/`](dot_config/bottom/) | System monitor |
| GitHub CLI | [`gh/`](dot_config/gh/) | Dual host configuration |
| Docker | [`docker/`](dot_config/docker/) | Docker Desktop |
| Copilot CLI | [`copilot/`](dot_config/copilot/) | GitHub Copilot CLI |
| Television | [`television/`](dot_config/television/) | Fuzzy picker |
| Worktrunk | [`worktrunk/`](dot_config/worktrunk/) | Git worktree manager |

### AI

| Tool | Config | Notes |
|---|---|---|
| Claude Code | [`claude/settings.json.tmpl`](dot_config/claude/settings.json.tmpl) | Claude settings |
| OpenCode | [`opencode/opencode.json.tmpl`](dot_config/opencode/opencode.json.tmpl) | Claude via local proxy, MCP servers (Context7, gh_grep), skills (chezmoi, nix-darwin) |
| HAI | [`hai/config.yaml`](dot_config/hai/config.yaml) | SAP Hyperspace AI tools |

### Media

| Tool | Config | Notes |
|---|---|---|
| Spicetify | [`spicetify/`](dot_config/spicetify/) | Spotify desktop theming |
| spotify-player | [`spotify-player/`](dot_config/spotify-player/) | Spotify TUI client |

### Email

| Tool | Config | Notes |
|---|---|---|
| Neomutt | [`neomutt/neomuttrc.tmpl`](dot_config/neomutt/neomuttrc.tmpl) | Gmail IMAP |

### Cloud

| Tool | Config | Notes |
|---|---|---|
| Databricks | [`databricks/databrickscfg.tmpl`](dot_config/databricks/databrickscfg.tmpl) | Test + prod workspaces |

### Security

| Scope | Path | Details |
|---|---|---|
| SSH | [`dot_ssh/`](dot_ssh/) | Known hosts |
| GPG | [`private_gnupg/`](dot_config/private_gnupg/) | Algorithm prefs, gpg-agent with SSH + pinentry-mac, public keys (personal + SAP) |

---

## Secrets Management

Files ending in `.tmpl` use the [Dashlane CLI](https://github.com/Dashlane/dashlane-cli) to inject secrets at apply time via chezmoi's `dashlanePassword` template function. **No credentials are stored in this repository.**

Templated secrets include:

- Anthropic API token (Claude Code, OpenCode)
- Databricks tokens (test + prod workspaces)
- Gmail app password (Neomutt)
