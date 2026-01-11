FROM node:20-alpine

RUN apk add --no-cache \
    git \
    curl \
    bash \
    ripgrep \
    openssh-client \
    ca-certificates

# Ensure the node user's home directory exists with correct permissions
RUN mkdir -p /home/node && chown -R node:node /home/node

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspace

ENV TERM=xterm-256color
ENV LANG=C.UTF-8
ENV HOME=/home/node

# Fix permissions again in case npm install modified the home directory
RUN chown -R node:node /home/node

USER node

ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
