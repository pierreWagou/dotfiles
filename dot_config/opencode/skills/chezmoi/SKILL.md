---
name: chezmoi
description: "ALWAYS load this skill when editing, creating, reading, or troubleshooting ANY config/dotfile (nvim, tmux, tmuxinator, zsh, ghostty, git, sesh, starship, mprocs, or anything under ~/.config/ or ~/). All dotfiles are managed by chezmoi -- edits MUST go through the chezmoi source state."
---

## What chezmoi is

Chezmoi is a dotfile manager. It maintains a **source state** (a git repo, typically at `~/.local/share/chezmoi`) that is applied to the **target state** (the home directory). Files in the source use special naming conventions that chezmoi interprets when applying.

## Source state location

- Source directory: `~/.local/share/chezmoi`
- Config: `~/.config/chezmoi/chezmoi.toml` (generated from `.chezmoi.toml.tmpl` in the source root)
- The source directory IS a git repo -- commit and push changes after editing

## File and directory naming conventions

Source names map to target names via these prefixes/suffixes (applied in order, all stripped from the target name):

### Prefixes (order matters when combined)

| Prefix | Effect |
|---|---|
| `create_` | Only create file if it does not already exist |
| `modify_` | Script that modifies an existing file |
| `remove_` | Remove the file/dir from target |
| `run_` | Script executed at every `chezmoi apply` |
| `run_once_` | Script executed only once |
| `run_onchange_` | Script re-executed when its contents change |
| `exact_` | Directory: remove files in target not present in source |
| `private_` | Set permissions to `0700` (dir) or `0600` (file) |
| `readonly_` | Set permissions to `0555` (dir) or `0444` (file) |
| `empty_` | Manage an empty file (chezmoi ignores empty files by default) |
| `encrypted_` | File is encrypted with age or gpg |
| `executable_` | Set the executable bit on the target file |
| `symlink_` | Create a symlink |
| `dot_` | Replace with `.` in the target name |

### Suffixes

| Suffix | Effect |
|---|---|
| `.tmpl` | Process through Go template engine, then strip suffix |
| `.literal` | Treat literally (no special name interpretation), strip suffix |

### Examples

| Source path | Target path |
|---|---|
| `dot_config/` | `~/.config/` |
| `dot_config/zsh/dot_zshrc.tmpl` | `~/.config/zsh/.zshrc` |
| `private_dot_ssh/` | `~/.ssh/` (mode 0700) |
| `executable_script.sh` | `~/script.sh` (with +x) |
| `run_once_install-packages.sh` | Executed once, no target file created |

## Templates (.tmpl files)

Chezmoi uses Go's `text/template` syntax. Template files have the `.tmpl` suffix.

### Available data

- `.chezmoi.os` -- operating system (`linux`, `darwin`, `windows`)
- `.chezmoi.arch` -- architecture (`amd64`, `arm64`)
- `.chezmoi.hostname` -- machine hostname
- `.chezmoi.username` -- current username
- `.chezmoi.homeDir` -- home directory path
- `.chezmoi.sourceDir` -- source state directory path
- Custom data defined in `.chezmoi.toml.tmpl` under `[data]`

### Template syntax

```
# Conditionals
{{ if eq .chezmoi.os "darwin" }}
# macOS-specific config
{{ else if eq .chezmoi.os "linux" }}
# Linux-specific config
{{ end }}

# Variable substitution
{{ .myVariable }}

# Pipeline with quote
{{ .myVariable | quote }}
```

### Config template (.chezmoi.toml.tmpl)

Located at the source root. Defines data variables and chezmoi settings. Common functions:

```toml
[data]
  # Prompt once and persist the answer
  email = {{ promptStringOnce . "email" "What is your email?" | quote }}
  profile = {{ promptChoiceOnce . "profile" "Which profile?" (list "work" "personal") | quote }}
```

### Secret management in templates

Chezmoi integrates with password managers. Common patterns:

```
# 1Password
{{ onepasswordRead "op://vault/item/field" }}

# Bitwarden
{{ (bitwarden "item" "my-item").login.password }}

# Dashlane
{{ (index (dashlanePassword "Entry Name") 0).password }}

# Age encryption (for encrypted_ files)
# Requires age key configured in chezmoi.toml

# Environment variable
{{ env "MY_SECRET" }}
```

## Key commands

| Command | What it does |
|---|---|
| `chezmoi add <file>` | Add a file from target to source state |
| `chezmoi add --template <file>` | Add as a template |
| `chezmoi apply` | Apply source state to target |
| `chezmoi apply --dry-run` | Preview what would change (safe) |
| `chezmoi diff` | Show diff between source and target |
| `chezmoi edit <file>` | Edit a file in source state |
| `chezmoi data` | Show available template data |
| `chezmoi execute-template` | Test template rendering |
| `chezmoi managed` | List all managed files |
| `chezmoi unmanaged` | List files in target not managed by chezmoi |
| `chezmoi forget <file>` | Stop managing a file (remove from source) |
| `chezmoi re-add` | Re-add modified target files to source |
| `chezmoi init --apply <repo>` | Clone repo and apply in one step |
| `chezmoi update` | Pull latest from remote and apply |
| `chezmoi cat <file>` | Show what chezmoi would write to target |
| `chezmoi source-path <file>` | Show the source path for a target file |

## .chezmoiignore

Located at source root. Lists **target paths** (not source paths) that chezmoi should skip. Supports glob patterns and Go templates:

```
# Ignore a specific file
.config/nvim/lazy-lock.json

# Ignore a directory
.config/chezmoi/**

# Conditional ignore
{{ if ne .chezmoi.os "darwin" }}
.config/ghostty/**
{{ end }}
```

## Workflow for editing dotfiles

1. **Edit in source**: Work in `~/.local/share/chezmoi/` directly
2. **Preview**: Run `chezmoi diff` to see what would change
3. **Apply**: Run `chezmoi apply` to deploy changes
4. **Commit**: `git add`, `git commit`, `git push` in the source directory

If you edited the target file directly instead:
1. Run `chezmoi re-add` to pull changes back into source
2. Or `chezmoi merge <file>` to merge conflicts

## Important rules when editing chezmoi-managed files

- ALWAYS edit the **source state** files (in `~/.local/share/chezmoi/`), never the target files directly
- Use the correct chezmoi naming conventions for new files
- When adding secrets, use template functions for password manager integration -- never hardcode secrets
- After editing `.tmpl` files, use `chezmoi cat <target-path>` to verify template rendering
- Run `chezmoi diff` before `chezmoi apply` to review changes
- The `.chezmoiignore` file uses **target paths**, not source paths
- When creating a new `.tmpl` file, ensure the Go template syntax is valid
- Remember that `dot_` translates to `.` -- do not create files starting with `.` in the source
