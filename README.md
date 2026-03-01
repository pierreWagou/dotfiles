# Dotfiles

Personal configuration files for macOS, managed with [chezmoi](https://chezmoi.io/).

## Shell

**[dot_zshrc](dot_zshrc)** - Zsh configuration
- Plugins via Nix: fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, zsh-you-should-use
- Starship prompt, Zoxide (cd replacement), Pyenv
- Catppuccin Mocha syntax highlighting theme
- Git aliases, eza (ls replacement)

## Terminal

**[dot_config/ghostty/config](dot_config/ghostty/config)** - Ghostty terminal emulator

**[dot_config/tmux/tmux.conf](dot_config/tmux/tmux.conf)** - Tmux multiplexer

## Tools

| Config | Description |
|--------|-------------|
| [dot_config/git/](dot_config/git/) | Git config with separate work (SAP) profile |
| [dot_config/fzf/config](dot_config/fzf/config) | FZF fuzzy finder (Catppuccin Mocha theme) |
| [dot_config/bat/config](dot_config/bat/config) | Bat (cat replacement) |
| [dot_config/starship.toml](dot_config/starship.toml) | Starship prompt |
| [dot_config/gh/](dot_config/gh/) | GitHub CLI |
| [dot_config/hai/config.yaml](dot_config/hai/config.yaml) | SAP AI tools |

## AI & Development

**[dot_claude/settings.json.tmpl](dot_claude/settings.json.tmpl)** - Claude Code settings
- Auth token pulled from Dashlane

**[dot_databrickscfg.tmpl](dot_databrickscfg.tmpl)** - Databricks workspaces
- Tokens pulled from Dashlane (test, prod)

## Security

**[dot_gnupg/](dot_gnupg/)** - GPG configuration
- `gpg.conf` - Algorithm preferences, security settings
- `gpg-agent.conf` - SSH support, pinentry-mac
- `keys/` - Public keys (personal + SAP)

## Secrets Management

Files ending in `.tmpl` use [Dashlane CLI](https://github.com/Dashlane/dashlane-cli) to inject secrets at apply time. No credentials are stored in this repository.
