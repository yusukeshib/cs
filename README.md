# claude-sandbox

Run Claude Code with `--dangerously-skip-permissions` safely in ephemeral Docker containers.

## Features

- **Ephemeral containers** - Auto-destroyed after each session (`--rm`)
- **Full interactive TUI** - Arrow keys, Ctrl+C, multiline input all work
- **Persistent history** - Conversation history saved via `~/.claude` mount
- **Sandboxed execution** - Only your project directory is accessible
- **Simple invocation** - Just `cs` from any project directory

## Installation

### 1. Build the Docker image

```bash
cd ~/projects/claude-sandbox
docker build -t claude-sandbox:latest .
```

### 2. Set your API key

Add to `~/.zshrc` or `~/.bashrc`:

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

### 3. Add to PATH

```bash
export PATH="$PATH:$HOME/projects/claude-sandbox"
alias cs='claude-sandbox.sh'
```

### 4. Reload shell

```bash
source ~/.zshrc  # or ~/.bashrc
```

## Usage

```bash
# Interactive session in current directory
cs

# Interactive session in specific project
cs ~/projects/my-app

# One-shot command
cs ~/projects/my-app "explain this codebase"

# Restrict to specific tools
cs --allowedTools "Read,Edit,Grep,Glob"
```

## Security Model

| Aspect | Protection |
|--------|------------|
| File system | Only project dir + `~/.claude` mounted |
| Host system | Fully isolated from container |
| Container | Destroyed after each exit |
| Credentials | API key via env var, not stored in image |
| History | Persists in `~/.claude` on host |

## Optional: Fresh Sessions

If you want sessions without history persistence:

```bash
alias cs-fresh='docker run --rm -it -v "$(pwd):/workspace" -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" -w /workspace claude-sandbox:latest'
```

## Rebuilding

After updating the Dockerfile:

```bash
docker build -t claude-sandbox:latest ~/projects/claude-sandbox/
```

## License

MIT
