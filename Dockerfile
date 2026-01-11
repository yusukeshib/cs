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

WORKDIR /workspace

ENV TERM=xterm-256color
ENV LANG=C.UTF-8
ENV HOME=/home/node

ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
