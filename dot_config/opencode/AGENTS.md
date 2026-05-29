# Global Rules

## Code Quality

- Treat every line of code as a liability. Less code is better. Prefer deleting code over adding it.
- Favour readability and maintainability over cleverness.
- Do not introduce abstractions until the duplication is proven (Rule of Three).
- Every dependency added is a maintenance burden — justify it.
- No dead code, no commented-out code.

## Security

- Never hardcode secrets, tokens, or credentials.
- Validate and sanitize all external input.
- Use rbw (Bitwarden CLI) in chezmoi templates for secrets.

## Environment

- Dotfiles are managed by chezmoi — always edit the source state at ~/.local/share/chezmoi, never target files directly. Load the chezmoi skill when working with any dotfile.
- System configuration uses Nix (nix-darwin on macOS, NixOS on Linux). For system-level changes, modify the flake at ~/.config/wagounix, don't install manually. Load the nix-darwin or nixos skill as appropriate.

## Coding Style

- Code should be self-documenting. Comments should only explain hard-to-read and specific behaviors.
- Use conventional commits (feat:, fix:, chore:, docs:, refactor:).
- When developing a feature for a codebase with a testing framework, test it and follow the existing patterns.
- Don't create files unless absolutely necessary (especially markdown/docs).

## Diagrams

- Always use mermaid code blocks (```mermaid) for diagrams and flowcharts. Never generate raw ASCII art — a plugin renders mermaid to ASCII automatically.
- Prefer top-down (TD) layout over left-right (LR) to avoid horizontal overflow.
- Keep diagrams concise — they render as ASCII art in a terminal at large font size. Favour fewer nodes with clear labels over exhaustive detail.
- Supported types: flowcharts (graph TD/LR/BT/RL), state diagrams, sequence diagrams, class diagrams, ER diagrams, XY charts. Do NOT use unsupported types (pie, gantt, mindmap, timeline, etc.).
- Do NOT use \n or HTML tags in node labels — they are not rendered. Use short single-line labels instead.

## Behavior

- Ask before making changes when the approach is ambiguous or involves tradeoffs.
- When a project has its own AGENTS.md, defer to it for project-specific conventions.
- Don't commit unless explicitly asked. Don't push unless explicitly asked.
- Always check for existing tests before modifying logic.
- When unsure about a framework API, use context7 to check current docs before guessing.
- If unsure how to implement something, use gh_grep to search real code examples from GitHub.
