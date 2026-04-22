#!/bin/bash
# Generate age key from SSH private key for SOPS decryption
# This runs once per machine via chezmoi

KEYS_DIR="$HOME/.config/sops/age"
KEYS_FILE="$KEYS_DIR/keys.txt"

if [ -f "$KEYS_FILE" ] && [ -s "$KEYS_FILE" ]; then
  echo "sops age key already exists at $KEYS_FILE"
  exit 0
fi

if ! command -v ssh-to-age &> /dev/null; then
  echo "ssh-to-age not found, skipping sops age key generation"
  exit 0
fi

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "SSH key not found at $HOME/.ssh/id_ed25519, skipping"
  exit 0
fi

mkdir -p "$KEYS_DIR"
echo "Generating sops age key from SSH key (passphrase may be required)..."
ssh-to-age -private-key -i "$HOME/.ssh/id_ed25519" > "$KEYS_FILE"
chmod 600 "$KEYS_FILE"
echo "sops age key generated at $KEYS_FILE"
