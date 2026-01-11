#!/bin/bash
# cs installer
# Usage: curl -fsSL https://raw.githubusercontent.com/yusukeshib/cs/main/install.sh | bash

set -e

INSTALL_DIR="${CLAUDE_SANDBOX_DIR:-$HOME/.cs}"
BIN_DIR="$HOME/.local/bin"
REPO_URL="https://github.com/yusukeshib/cs.git"

echo "Installing cs..."

# Clone or update repository
if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull --quiet
else
    echo "Cloning repository..."
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Build Docker image
echo "Building Docker image..."
docker build --quiet -t cs:latest .

# Install to ~/.local/bin
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/cs.sh" "$BIN_DIR/cs"
echo "Installed to $BIN_DIR/cs"

echo ""
echo "Installation complete!"
echo ""
echo "Ensure ~/.local/bin is in your PATH, then run: cs <project_dir>"
echo ""
echo "Authentication is shared from your host ~/.claude directory."
