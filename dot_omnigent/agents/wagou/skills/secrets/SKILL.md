---
name: secrets
description: Secret management using rbw (Bitwarden CLI) for chezmoi templates and system config.
---

# secrets — secure credential management

This skill provides guidance for managing secrets using rbw (Bitwarden CLI).

## Usage

Use this skill when:
- Adding secrets to chezmoi templates
- Retrieving API tokens or passwords
- Managing credentials for services

## rbw Basics

### Get a secret
```bash
rbw get "Item Name"
```

### Get a specific field
```bash
rbw get "Item Name" --field "username"
rbw get "Item Name" --field "password"
```

### List items
```bash
rbw list
```

## Chezmoi Integration

In chezmoi templates (`.tmpl` files), use:

```yaml
{{- $secret := (rbw "Item Name").data.password -}}
password: {{ $secret }}
```

Or for specific fields:

```yaml
{{- $item := (rbw "Item Name") -}}
username: {{ $item.data.username }}
password: {{ $item.data.password }}
api_key: {{ $item.data.api_key }}
```

## Best Practices

1. **Never hardcode secrets** — always use rbw
2. **Use templates** — chezmoi `.tmpl` files for dynamic secrets
3. **Organize vault** — group related secrets together
4. **Rotate regularly** — update secrets periodically

## Troubleshooting

### rbw not found
```bash
# Ensure rbw is installed
nix-env -iA nixpkgs.rbw
# Or add to system packages in NixOS config
```

### Authentication issues
```bash
# Check rbw status
rbw status
# Re-authenticate if needed
rbw unlock
```
