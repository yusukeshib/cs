FROM node:20-alpine

RUN apk add --no-cache \
    git \
    curl \
    bash \
    ripgrep \
    openssh-client \
    ca-certificates

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Create non-root user
RUN addgroup -S claude && adduser -S claude -G claude

WORKDIR /workspace
RUN chown claude:claude /workspace

USER claude

ENV TERM=xterm-256color
ENV LANG=C.UTF-8

ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
