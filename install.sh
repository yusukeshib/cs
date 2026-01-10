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
ln -sf "$INSTALL_DIR/cs.sh" "$BIN_DIR/cs"
echo "Installed to $BIN_DIR/cs (and cs)"

# Detect shell config file
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Ensure ~/.local/bin is in PATH
if ! grep -q '\.local/bin' "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo '# Add ~/.local/bin to PATH' >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo "Added ~/.local/bin to PATH in $SHELL_RC"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Reload shell:  source $SHELL_RC"
echo "  2. Run:           cs"
echo ""
echo "Authentication is shared from your host ~/.claude directory."
