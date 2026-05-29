# Chezmoi Source State

This repo is the chezmoi source state. Files here are applied to the home directory via `chezmoi apply`.

## Structure

- `dot_config/` → `~/.config/` (29 configs: nvim, zsh, tmux, opencode, ghostty, git, etc.)
- `private_dot_ssh/` → `~/.ssh/` (mode 0700)
- `dot_zshenv.tmpl` → `~/.zshenv`
- `Library/` → `~/Library/` (macOS-specific)
- `.chezmoi.toml.tmpl` → chezmoi config (defines `nixProfile` data variable)
- `.chezmoiignore` → conditional ignores based on `nixProfile`

## Template Data

Available in `.tmpl` files:
- `.nixProfile` — one of: `sap`, `wagoumac`, `wagou-old`, `wagoulab`
- `.chezmoi.os` — `darwin` or `linux`
- `.chezmoi.hostname`, `.chezmoi.username`, `.chezmoi.homeDir`

## Conventions

- Naming: use chezmoi prefixes (`dot_`, `private_`, `executable_`, `exact_`) and `.tmpl` suffix
- Secrets: use `{{ (rbw "Item Name").data.password }}` — never hardcode
- Host-specific logic: use `{{ if eq .nixProfile "sap" }}` conditionals in templates
- Verify templates: run `chezmoi cat <target-path>` before applying

## Workflow

1. Edit files in this repo (the source state)
2. Run `chezmoi diff` to preview changes
3. Run `chezmoi apply` to deploy
4. Commit and push

## Do NOT

- Create files starting with `.` in source (use `dot_` prefix instead)
- Edit target files directly (`~/.config/*`, `~/.*`)
- Commit secrets in plaintext
- Modify `.config/nvim/lazy-lock.json` (ignored, managed by lazy.nvim)
- Modify `.config/tmux/plugins/` (ignored, managed by tpm)
