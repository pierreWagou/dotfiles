---
name: readme
description: Write polished, well-structured README.md files. Load this skill when creating or improving a project README.
---

## Structure

A good README follows this order. Not every section is required — use what fits the project.

1. **Banner** — visual header (SVG or image, centered)
2. **Badges** — CI status, license, tech stack (centered, below banner)
3. **One-liner** — single sentence describing the project
4. **Overview** — bullet list of key features / design goals
5. **Architecture** — visual diagram showing how components relate
6. **Structure** — simplified directory tree (2-3 levels), with collapsible full tree
7. **Getting Started** — installation, bootstrap, rebuild commands
8. **Development** — dev workflow, hooks, CI, testing
9. **Quick Reference** — compact cheat sheet table of common commands
10. **License** — link to LICENSE file

## Formatting rules

- Use `<div align="center">` to center the header section (banner + badges)
- Separate the header from content with `---`
- Use **tables** for structured data (hosts, hooks, CI jobs, commands) — not bullet lists
- Use **`<details>` / `<summary>`** for secondary information (full directory tree, alternative install steps)
- Keep the primary directory tree to 2-3 levels deep — detail goes in collapsible sections
- Section headers should be concise: "Structure" not "Repository Structure", "Hosts" not "Host Profiles"
- Code blocks must specify the language (`bash`, `nix`, etc.)
- No trailing whitespace, no double blank lines

## Banner

Use the [capsule-render](https://github.com/kyechan99/capsule-render) service for banners. It generates dynamic SVG headers via URL params — no assets to commit, no maintenance.

### Capsule-render template

```markdown
![header](https://capsule-render.vercel.app/api?type=waving&height=220&color=0:cba6f7,25:b4befe,50:89dceb,75:f5c2e7,100:f38ba8&text=PROJECT_NAME&fontSize=60&fontColor=11111b&desc=CATCHY_ONE_LINER&descSize=18&descAlignY=62&descAlign=50&fontAlignY=38&animation=fadeIn&fontAlign=50)
```

### Default parameters

| Param | Value | Notes |
|---|---|---|
| `type` | `waving` | Animated wave shape |
| `height` | `220` | |
| `color` | `0:cba6f7,25:b4befe,50:89dceb,75:f5c2e7,100:f38ba8` | Catppuccin Mocha gradient: Mauve → Lavender → Sky → Pink → Red |
| `fontSize` | `60` | |
| `fontColor` | `11111b` | Catppuccin Mocha Crust (dark on vivid background) |
| `descSize` | `18` | |
| `animation` | `fadeIn` | |

### Color palette — Catppuccin Mocha accents

Use these vivid accents for the gradient `color` param. Pick 3–5 stops for a rich look.

| Name | Hex | Usage |
|---|---|---|
| Mauve | `cba6f7` | Primary accent, gradient start |
| Lavender | `b4befe` | Secondary accent |
| Sky | `89dceb` | Cyan touch |
| Pink | `f5c2e7` | Warm accent |
| Red | `f38ba8` | Gradient end, energetic pop |
| Peach | `fab387` | Warm alternative to Red |
| Yellow | `f9e2af` | Bright highlight |
| Green | `a6e3a1` | Nature / success accent |
| Teal | `94e2d5` | Cool alternative to Sky |
| Blue | `89b4fa` | Calm, technical accent |

For `fontColor`, use Crust `11111b` (dark text on vivid background) or Text `cdd6f4` (light text on dark background).

### Customization per repo

Replace these in the template URL:
1. **`text=`** — project/repo name
2. **`desc=`** — catchy one-liner (use `%20` for spaces, avoid `#`, `&`, `/`)
3. **`color=`** — adjust gradient stops if needed (pick colors that suit the project)

### Subtitle guidelines

The `desc` should be a **catchy one-liner** — personality over description. Don't repeat what the badges already say. Examples:
- `there's no place like ~/` (dotfiles)
- `declare everything, regret nothing` (nix config)
- `your stack, automated` (infra)

## Badges

Use [shields.io](https://shields.io/) for badges. Common patterns:

```markdown
<!-- CI status (dynamic) -->
[![Check](https://github.com/OWNER/REPO/actions/workflows/check.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/check.yml)

<!-- License (static) -->
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

<!-- Tech stack (static) -->
![Badge](https://img.shields.io/badge/Label-Value-COLOR?logo=LOGO&logoColor=white)
```

- Use flat style (default) — not `for-the-badge` or `flat-square`
- Group badges on one line, centered
- Only include badges that provide value — CI status, license, key technologies
- Do not use badges as decoration

## Architecture diagrams

Use ASCII box diagrams for showing how components relate:

```
 ┌─────────────────────────────────┐
 │           top level             │
 ├────────────────┬────────────────┤
 │   component A  │  component B   │  layer name
 ├───────┬────────┼───────┬────────┤
 │ sub-1 │ sub-2  │ sub-3 │ sub-4  │  layer name
 └───────┴────────┴───────┴────────┘
```

- Use Unicode box-drawing characters (`┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼ │ ─`)
- Annotate layers on the right side
- Keep it to 3-4 levels max
- Wrap in a code block for monospace rendering

## Tables

Use tables for:
- **Host profiles** — name, system, description
- **Commands** — action + command (quick reference)
- **CI jobs** — job name, runner, what it checks
- **Hooks** — stage, tool, description

Keep tables concise — no full sentences in cells, just keywords.

## Collapsible sections

```markdown
<details>
<summary>Section title</summary>

Content here (must have blank line after `<summary>` tag).

</details>
```

Use for:
- Full directory trees (when a simplified tree is shown above)
- Alternative installation methods
- Detailed configuration examples
- Anything that's useful but not primary

## Quick Reference

Always end with a quick reference table for the most common operations:

```markdown
## Quick Reference

| Action | Command |
|--------|---------|
| Build | `make build` |
| Test | `make test` |
| Deploy | `make deploy` |
```

Keep it to 5-8 rows max. Only the commands someone would use daily.

## Anti-patterns to avoid

- **Wall of text** at the top — lead with visuals and structure, not paragraphs
- **Badges as decoration** — every badge should convey useful information
- **Giant directory trees** inline — collapse them
- **Screenshots that will go stale** — prefer diagrams or text descriptions
- **"Table of Contents"** section — GitHub auto-generates one; manual TOCs go stale
- **Emojis in headers** — unless the project's tone explicitly calls for it
- **External image hosting** — commit assets to the repo (under `assets/`)
