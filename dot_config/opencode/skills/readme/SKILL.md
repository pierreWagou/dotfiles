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

Prefer a self-hosted SVG at `assets/banner.svg` over external services:

- **No external dependencies** — no capsule-render, no shields.io for the banner itself
- **Dark/light mode** — SVG can use `prefers-color-scheme` media queries
- **Version controlled** — changes are tracked in git
- GitHub sanitizes SVGs — avoid `<script>`, `<foreignObject>`, and complex CSS. Simple `filter` effects (blur, merge) may be stripped.

### Design priorities

1. **Project identity first** — the banner should visually communicate what the repo does. Pick a hero element that represents the project's domain (a car for a vehicle project, a network graph for infra, a chart for analytics, etc.). This element should be **prominent**, not a subtle decoration.
2. **Synthwave / outrun as aesthetic** — apply the style as a visual language (color palette, glow effects, retro mood), not as a mandatory scene to reproduce. Not every banner needs a grid, sun, and horizon — use the elements that serve the composition.

### Color palette

Deep purples (`#0f0c29`, `#302b63`), hot pinks (`#ff6ec7`), neon blues (`#7eb5e6`, `#5277C3`), lavender (`#e0b0ff`), sunset gold (`#f9a825`). Dark gradient backgrounds (purple-to-indigo or navy-to-neon-blue).

### Style toolkit

Pick from these to complement the hero element — not all are required:

- **Neon outlines** — stroke project-specific shapes with palette colors
- **Glow effects** — gaussian blur filter on key elements for a neon sign look
- **Gradient backgrounds** — dark, moody, using the palette above
- **Retro scan lines** — horizontal bands with increasing thickness (clip to parent shape)
- **Perspective grid** — converging lines on a ground plane
- **Setting sun** — half-circle at the horizon, pink-to-gold gradient
- **Scattered stars** — small white circles with varying opacity
- **Title** — large, bold, white, with optional glow filter
- **Subtitle** — uppercase, letter-spaced, in lavender or soft pink

### SVG banner template

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 200" width="800" height="200">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#COLOR1" />
      <stop offset="100%" style="stop-color:#COLOR2" />
    </linearGradient>
  </defs>
  <rect width="800" height="200" fill="url(#bg)" />
  <text x="400" y="90" text-anchor="middle" font-family="sans-serif" font-size="48" font-weight="700" fill="#ffffff">
    Project Name
  </text>
  <text x="400" y="130" text-anchor="middle" font-family="sans-serif" font-size="16" fill="#cccccc">
    Short description
  </text>
</svg>
```

Reference in README: `![header](assets/banner.svg)`

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
