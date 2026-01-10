#!/bin/bash
# cs - Run Claude Code in ephemeral Docker container with persistent history

set -e

# Default to current directory if no project path given
PROJECT_DIR="${1:-$(pwd)}"

# Shift if first arg was a directory path
if [[ -d "$1" ]]; then
    shift
fi

# Ensure ~/.claude exists for history/auth persistence
mkdir -p "${HOME}/.claude"

# Build docker args
DOCKER_ARGS=(
    --rm -it
    -v "${PROJECT_DIR}:/workspace"
    -v "${HOME}/.claude:/root/.claude"
    -w /workspace
)

# Only pass API key if explicitly set (otherwise use mounted ~/.claude auth)
if [[ -n "${ANTHROPIC_API_KEY}" ]]; then
    DOCKER_ARGS+=(-e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}")
fi

docker run "${DOCKER_ARGS[@]}" cs:latest "$@"
