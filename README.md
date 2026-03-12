# N3XAI DevOps

DevOps bootstrap toolkit for Ubuntu/Debian servers, packaged as a `.deb`, focused on:

- base system provisioning
- Docker Engine and Docker Compose plugin
- Codex CLI environment (Node.js + `@openai/codex`)
- MCP (Model Context Protocol) tooling
- MCP server generation and orchestration

French version: `README.fr.md`

## What This Project Installs

Primary install paths:

- `/usr/local/bin`
- `/opt/n3xai/setup-devops`
- `/opt/bootstrap`
- `/etc/n3xai`

Main entrypoint:

- `n3xai-install`

Menu options in `n3xai-install`:

1. Base System
2. Docker Engine
3. Codex CLI
4. MCP Tools
5. MCP Generator
6. MCP Orchestrator
7. Full Install (runs steps 1 to 6)

## Installation Steps (Detailed)

### 1) Base System (`opt/n3xai/setup-devops/01-base-system.sh`)

- runs `apt update && apt upgrade -y`
- installs:
`curl`, `wget`, `git`, `jq`, `unzip`, `build-essential`, `software-properties-common`, `apt-transport-https`, `ca-certificates`, `lsb-release`, `gnupg`

### 2) Docker Engine (`opt/n3xai/setup-devops/02-docker-engine.sh`)

- removes old Docker packages (`docker`, `docker.io`, `containerd`, `runc`, etc.)
- configures Docker official APT repository
- installs:
`docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`
- enables and starts `docker` service

### 3) Codex CLI (`opt/n3xai/setup-devops/03-codex-cli.sh`)

- installs `curl` and `git`
- installs Node.js LTS from NodeSource
- installs globally:
`@openai/codex`

### 4) MCP Tools (`opt/n3xai/setup-devops/04-mcp-tools.sh`)

- installs:
`python3`, `python3-full`, `python3-pip`, `python3-venv`, `jq`, `git`, `curl`
- creates MCP structure:
`/root/mcp/{servers,logs,registry,runtime,templates,build}`
- creates server category directories:
`/root/mcp/servers/{docker,aws,aapanel,dns}`
- creates Python virtual environment:
`/root/mcp/venv`
- installs Python dependencies in venv:
`fastapi`, `uvicorn`, `pydantic`, `requests`, `pyyaml`, `watchdog`

### 5) MCP Generator (`opt/n3xai/setup-devops/05-mcp-generator.sh`)

- creates `create-mcp-server` under `/opt/n3xai/mcp-generator`
- symlinks it to `/usr/local/bin/create-mcp-server`
- generator creates a minimal `server.py` in `/root/mcp/servers/<name>`

### 6) MCP Orchestrator (`opt/n3xai/setup-devops/06-mcp-orchestrator.sh`)

- creates `orchestrator.py` under `/opt/n3xai/mcp-orchestrator`
- symlinks it to `/usr/local/bin/mcp-orchestrator`
- orchestrator behavior:
- discovers `server.py` files in `/root/mcp/servers`
- starts each server process
- monitors and restarts stopped processes

## CLI Tools Provided (`usr/local/bin`)

- `n3xai-install`: interactive installation menu
- `create-mcp-server`: create MCP server skeleton
- `mcp-from-openapi <url> <name>`: download OpenAPI file and generate MCP stub
- `mcp-register <name> <path>`: append server entry into `/root/mcp/registry/registry.json`
- `mcp-dockerize <name>`: generate Dockerfile and build `mcp-<name>` image

## Additional Bootstrap Scripts (`opt/bootstrap`)

These are not called automatically by `n3xai-install` but are provided for ops workflows:

- `users.sh`
- reads `/etc/n3xai/env.conf`
- creates two admin users and adds them to `sudo`
- `ssh-hardening.sh`
- edits `sshd_config` (`PermitRootLogin` / `PasswordAuthentication`)
- restarts SSH service
- `postgresql.sh`
- installs PostgreSQL
- creates database/user/grants from `env.conf`
- `docker-registry.sh`
- runs private Docker registry container (`registry:2`) on port `5000`

## Configuration

Main config file:

- `etc/n3xai/env.conf`

Template file for public/open source usage:

- `etc/n3xai/env.conf.example`

Important variables:

- PostgreSQL: `POSTGRE_*`
- admin accounts: `ADMIN*_USER`, `ADMIN*_PASS`, `ADMIN*_EMAIL`
- MCP env: `MCP_HOME`, `MCP_VENV`, `PATH`

## Build and Install (`.deb`)

From `/root`:

```bash
cd /root
./n3xai-devops-codex/build.sh
sudo dpkg -i n3xai-devops-codex.deb
```

Run installer:

```bash
sudo n3xai-install
```

## MCP Quick Start

```bash
# Create a new MCP server
create-mcp-server

# Start orchestrator (if installed)
mcp-orchestrator

# Register a server
mcp-register myserver /root/mcp/servers/myserver/server.py
```

## Security Notes

- Default values in `etc/n3xai/env.conf` are placeholders and must be changed before production use.
- Never commit real passwords, PATs, or private keys.
- Scripts assume root-level execution on Ubuntu/Debian with APT and systemd.

## Known Limitations

- `ssh-hardening.sh` keeps `PasswordAuthentication yes`; this may not match strict hardening policies.
- Scripts are not fully idempotent in all edge cases (for example pre-existing symlinks/resources).

## License

Add an explicit open-source license file (`LICENSE`) before wider distribution.
