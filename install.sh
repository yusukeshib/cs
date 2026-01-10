#!/bin/bash
# claude-sandbox installer
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-sandbox/main/install.sh | bash

set -e

INSTALL_DIR="${CLAUDE_SANDBOX_DIR:-$HOME/.claude-sandbox}"
REPO_URL="https://github.com/YOUR_USERNAME/claude-sandbox.git"

echo "Installing claude-sandbox..."

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
docker build -t claude-sandbox:latest . --quiet

# Make script executable
chmod +x "$INSTALL_DIR/claude-sandbox.sh"

# Detect shell config file
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Add to PATH if not already present
if ! grep -q "claude-sandbox" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# claude-sandbox - ephemeral Docker environment for Claude Code" >> "$SHELL_RC"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
    echo "alias cs='claude-sandbox.sh'" >> "$SHELL_RC"
    echo "Added to $SHELL_RC"
else
    echo "Already in $SHELL_RC"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Set your API key:  export ANTHROPIC_API_KEY=\"your-key\""
echo "  2. Reload shell:      source $SHELL_RC"
echo "  3. Run:               cs"
