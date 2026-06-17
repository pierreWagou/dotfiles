#!/bin/sh
# Allow all managed .envrc files so direnv loads them automatically.
# This script re-runs whenever any .envrc content changes (run_onchange_).

# wagou projects
# wagou: {{ include "Projects/wagou/dot_envrc" | sha256sum }}
direnv allow "$HOME/Projects/wagou"

# alan projects
# alan: {{ include "Projects/alan/dot_envrc" | sha256sum }}
direnv allow "$HOME/Projects/alan"
