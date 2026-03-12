#!/bin/bash

echo "Installing Codex CLI environment..."

apt update

apt install -y curl git

# NodeJS LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

apt install -y nodejs

node -v
npm -v

echo "Installing Codex CLI..."

npm install -g @openai/codex

echo "Codex CLI installed."

echo ""
echo "Test with:"
echo "codex"
echo ""