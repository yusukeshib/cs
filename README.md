# claude-sandbox

Run Claude Code with `--dangerously-skip-permissions` safely in ephemeral Docker containers.

## Features

- **Ephemeral containers** - Auto-destroyed after each session (`--rm`)
- **Full interactive TUI** - Arrow keys, Ctrl+C, multiline input all work
- **Persistent history** - Conversation history saved via `~/.claude` mount
- **Sandboxed execution** - Only your project directory is accessible
- **Simple invocation** - Just `cs` from any project directory

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-sandbox/main/install.sh | bash
```

This will:
1. Clone the repo to `~/.claude-sandbox`
2. Build the Docker image
3. Symlink `claude-sandbox` and `cs` to `~/.local/bin`

## Manual Installation

### 1. Clone and build

```bash
git clone https://github.com/YOUR_USERNAME/claude-sandbox.git ~/.claude-sandbox
cd ~/.claude-sandbox
docker build -t claude-sandbox:latest .
```

### 2. Set your API key

Add to `~/.zshrc` or `~/.bashrc`:

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

### 3. Install to ~/.local/bin

```bash
mkdir -p ~/.local/bin
ln -sf ~/.claude-sandbox/claude-sandbox.sh ~/.local/bin/claude-sandbox
ln -sf ~/.claude-sandbox/claude-sandbox.sh ~/.local/bin/cs
```

### 4. Ensure ~/.local/bin is in PATH

Add to `~/.zshrc` or `~/.bashrc` if not already present:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 5. Reload shell

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
