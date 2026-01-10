# cs

Run Claude Code with `--dangerously-skip-permissions` safely in ephemeral Docker containers.

## Features

- **Ephemeral containers** - Auto-destroyed after each session (`--rm`)
- **Full interactive TUI** - Arrow keys, Ctrl+C, multiline input all work
- **Shared authentication** - Uses your host's `~/.claude` credentials (no extra setup)
- **Persistent history** - Conversation history saved via `~/.claude` mount
- **Sandboxed execution** - Only your project directory is accessible
- **Simple invocation** - Just `cs` from any project directory

## Quick Install

```bash
curl -fsSL https://raw.github.com/yusukeshib/cs/main/install.sh | bash
```

This will:
1. Clone the repo to `~/.cs`
2. Build the Docker image
3. Symlink `cs` and `cs` to `~/.local/bin`

## Manual Installation

### 1. Clone and build

```bash
git clone https://github.com/yusukeshib/cs.git ~/.cs
cd ~/.cs
docker build -t cs:latest .
```

### 2. Install to ~/.local/bin

```bash
mkdir -p ~/.local/bin
ln -sf ~/.cs/cs.sh ~/.local/bin/cs
ln -sf ~/.cs/cs.sh ~/.local/bin/cs
```

### 3. Ensure ~/.local/bin is in PATH

Add to `~/.zshrc` or `~/.bashrc` if not already present:

```bash
export PATH="$HOME/.local/bin:$PATH"
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
| Auth | Shared from host `~/.claude` (no env vars needed) |
| History | Persists in `~/.claude` on host |

## Optional: Fresh Sessions

If you want sessions without history persistence:

```bash
alias cs-fresh='docker run --rm -it -v "$(pwd):/workspace" -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" -w /workspace cs:latest'
```

## Rebuilding

After updating the Dockerfile:

```bash
docker build -t cs:latest ~/projects/cs/
```

## License

MIT
