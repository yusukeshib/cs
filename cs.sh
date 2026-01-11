#!/bin/bash
# cs - Run Claude Code in ephemeral Docker container with persistent history

set -e

# Pull latest cs source
git -C "${HOME}/.cs" pull --ff-only

# Require project directory as first argument
if [[ -z "$1" || ! -d "$1" ]]; then
    echo "Usage: cs <project_dir> [claude args...]" >&2
    exit 1
fi

PROJECT_DIR="$1"
shift

# Ensure ~/.claude exists for history/auth persistence
mkdir -p "${HOME}/.claude"

# Build docker args
DOCKER_ARGS=(
    --rm -it
    --user "$(id -u):$(id -g)"
    -v "${PROJECT_DIR}:/workspace"
    -v "${HOME}/.claude:/home/node/.claude"
    -w /workspace
)

# Only pass API key if explicitly set (otherwise use mounted ~/.claude auth)
if [[ -n "${ANTHROPIC_API_KEY}" ]]; then
    DOCKER_ARGS+=(-e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}")
fi

docker run "${DOCKER_ARGS[@]}" cs:latest "$@"
