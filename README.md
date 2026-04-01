# Dotfiles

Personal configuration files for macOS,
managed with [chezmoi][chezmoi].

All tools share a consistent
**Catppuccin Mocha** color scheme.

## Installation

### Prerequisites

- chezmoi installed via the
  [wagounix flake][wagounix]

### Setup

```bash
chezmoi init --apply pierreWagou
```

You will be prompted to select a nix profile
(`sap` or `wagou`).

## Shell

[dot_config/zsh/dot_zshrc.tmpl](dot_config/zsh/dot_zshrc.tmpl)

Zsh configuration
(ZDOTDIR relocated to `~/.config/zsh`).

- Plugin manager: [Sheldon][sheldon]
  - zsh-completions, fzf-tab,
    zsh-autosuggestions,
    fast-syntax-highlighting, you-should-use
- Prompt: [Starship][starship]
- Navigation: [Zoxide][zoxide] (cd replacement),
  [fzf][fzf]
- Aliases: [eza][eza] (ls replacement),
  git shortcuts,
  system commands (`update`, `build`, `vpn`)
- Node: [fnm][fnm] (Fast Node Manager)

## Terminal

| Config | Description |
| --- | --- |
| [ghostty][gh-c] | Ghostty (JetBrainsMono Nerd Font) |
| [tmux][tm-c] | Tmux (`C-Space`, vim-tmux-nav, TPM) |
| [tmuxinator][ti-c] | `dev` layout (nvim + opencode + term) |
| [sesh][se-c] | Sesh session manager |

[gh-c]: dot_config/ghostty/config
[tm-c]: dot_config/tmux/tmux.conf
[ti-c]: dot_config/tmuxinator/
[se-c]: dot_config/sesh/

## Editor

[dot_config/nvim/](dot_config/nvim/) -
Neovim (LazyVim distribution)

- Languages: Java, Python, TypeScript,
  JSON, YAML, TOML, Markdown, SAP CDS
- Plugins: Telescope, Harpoon2, Aerial,
  DAP, Copilot, vim-tmux-navigator,
  yanky, venv-selector
- Coding: blink completions, mini-comment,
  mini-surround, inc-rename
- UI: dashboard, indent-blankline,
  treesitter-context, lualine

## Tools

| Config | Description |
| --- | --- |
| [git][git-c] | Git (conditional SAP profile, Delta) |
| [fzf][fzf-c] | FZF fuzzy finder |
| [bat][bat-c] | Bat (cat replacement) |
| [starship][st-c] | Starship prompt |
| [eza][eza-c] | Eza file type colors |
| [bottom][bt-c] | Bottom system monitor |
| [gh][gh2-c] | GitHub CLI (dual host) |
| [docker][dk-c] | Docker Desktop |
| [copilot][cp-c] | GitHub Copilot CLI |
| [television][tv-c] | Television fuzzy picker |
| [worktrunk][wt-c] | Worktrunk worktree manager |
| [spicetify][sp-c] | Spicetify (Spotify theming) |
| [spotify-player][spp-c] | spotify-player TUI client |
| [neomutt][nm-c] | Neomutt email client (Gmail IMAP) |
| [databricks][db-c] | Databricks workspaces (test + prod) |

[git-c]: dot_config/git/
[fzf-c]: dot_config/fzf/config
[bat-c]: dot_config/bat/config
[st-c]: dot_config/starship/starship.toml
[eza-c]: dot_config/eza/theme.yml
[bt-c]: dot_config/bottom/
[gh2-c]: dot_config/gh/
[dk-c]: dot_config/docker/
[cp-c]: dot_config/copilot/
[tv-c]: dot_config/television/
[wt-c]: dot_config/worktrunk/
[sp-c]: dot_config/spicetify/
[spp-c]: dot_config/spotify-player/
[nm-c]: dot_config/neomutt/neomuttrc.tmpl
[db-c]: dot_config/databricks/databrickscfg.tmpl

## AI

| Config | Description |
| --- | --- |
| [claude][cl-c] | Claude Code settings |
| [opencode][oc-c] | OpenCode (Claude via local proxy) |
| [hai][hai-c] | SAP Hyperspace AI tools |

[cl-c]: dot_config/claude/settings.json.tmpl
[oc-c]: dot_config/opencode/opencode.json.tmpl
[hai-c]: dot_config/hai/config.yaml

## Security

**[dot_ssh/](dot_ssh/)** - SSH

- `known_hosts` - Known SSH hosts

**[private_gnupg/](dot_config/private_gnupg/)** -
GPG

- `gpg.conf` - Algorithm preferences
- `gpg-agent.conf` - SSH support, pinentry-mac
- `keys/` - Public keys (personal + SAP)

## Secrets Management

Files ending in `.tmpl` use the
[Dashlane CLI][dashlane] to inject secrets
at apply time via chezmoi's
`dashlanePassword` template function.
No credentials are stored in this repository.

Templated secrets:

- Anthropic API token (Claude Code, OpenCode)
- Databricks tokens (test + prod workspaces)
- Gmail app password (Neomutt)

[chezmoi]: https://chezmoi.io/
[wagounix]: https://github.com/pierreWagou/wagounix
[sheldon]: https://sheldon.cli.rs/
[starship]: https://starship.rs/
[zoxide]: https://github.com/ajeetdsouza/zoxide
[fzf]: https://github.com/junegunn/fzf
[eza]: https://eza.rocks/
[fnm]: https://github.com/Schniz/fnm
[dashlane]: https://github.com/Dashlane/dashlane-cli
