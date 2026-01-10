#!/bin/bash
# claude-sandbox - Run Claude Code in ephemeral Docker container with persistent history

set -e

# Default to current directory if no project path given
PROJECT_DIR="${1:-$(pwd)}"

# Shift if first arg was a directory path
if [[ -d "$1" ]]; then
    shift
fi

# Ensure ~/.claude exists for history persistence
mkdir -p "${HOME}/.claude"

docker run --rm -it \
    -v "${PROJECT_DIR}:/workspace" \
    -v "${HOME}/.claude:/root/.claude" \
    -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
    -w /workspace \
    claude-sandbox:latest \
    "$@"
