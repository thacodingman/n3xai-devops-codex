# N3XAI DevOps

Bootstrap DevOps pour serveurs Ubuntu/Debian, packagé en `.deb`, orienté:

- base système
- Docker Engine + Docker Compose plugin
- environnement Codex CLI (Node.js + `@openai/codex`)
- outillage MCP (Model Context Protocol)
- génération/orchestration de serveurs MCP

Ce README décrit exactement ce que le projet installe et modifie sur une machine.

## Vue d'ensemble

Le package installe des scripts sous:

- `/usr/local/bin`
- `/opt/n3xai/setup-devops`
- `/opt/bootstrap`
- `/etc/n3xai`

Point d'entree principal:

- `n3xai-install`

Menu disponible via `n3xai-install`:

1. Base System
2. Docker Engine
3. Codex CLI
4. MCP Tools
5. MCP Generator
6. MCP Orchestrator
7. Full Install (1 -> 6)

## Ce que ca installe

### 1) Base system (`opt/n3xai/setup-devops/01-base-system.sh`)

- `apt update && apt upgrade -y`
- Paquets tries a installer:
`curl`, `wget`, `git`, `jq`, `unzip`, `build-essential`, `software-properties-common`, `apt-transport-https`, `ca-certificates`, `lsb-release`, `gnupg`

### 2) Docker Engine (`opt/n3xai/setup-devops/02-docker-engine.sh`)

- Supprime anciens paquets Docker (`docker`, `docker.io`, `containerd`, etc.)
- Ajoute le repo officiel Docker
- Installe:
`docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`
- Active et demarre le service `docker`

### 3) Codex CLI (`opt/n3xai/setup-devops/03-codex-cli.sh`)

- Installe `curl`, `git`
- Installe Node.js LTS (NodeSource)
- Installe globalement:
`@openai/codex`

### 4) MCP Tools (`opt/n3xai/setup-devops/04-mcp-tools.sh`)

- Installe:
`python3`, `python3-full`, `python3-pip`, `python3-venv`, `jq`, `git`, `curl`
- Cree l'arborescence MCP:
`/root/mcp/{servers,logs,registry,runtime,templates,build}`
- Cree sous-dossiers serveurs:
`/root/mcp/servers/{docker,aws,aapanel,dns}`
- Cree un venv Python:
`/root/mcp/venv`
- Installe dans le venv:
`fastapi`, `uvicorn`, `pydantic`, `requests`, `pyyaml`, `watchdog`

### 5) MCP Generator (`opt/n3xai/setup-devops/05-mcp-generator.sh`)

- Cree `create-mcp-server` dans `/opt/n3xai/mcp-generator`
- Cree un lien symbolique:
`/usr/local/bin/create-mcp-server`
- Le generateur produit un `server.py` minimal par serveur dans `/root/mcp/servers/<name>`

### 6) MCP Orchestrator (`opt/n3xai/setup-devops/06-mcp-orchestrator.sh`)

- Cree `orchestrator.py` dans `/opt/n3xai/mcp-orchestrator`
- Cree un lien symbolique:
`/usr/local/bin/mcp-orchestrator`
- L'orchestrateur:
- detecte les `server.py` sous `/root/mcp/servers`
- lance chaque serveur Python
- surveille et redemarre les processus arretes

## Outils CLI fournis (`usr/local/bin`)

- `n3xai-install`: menu d'installation principal
- `create-mcp-server`: cree un squelette de serveur MCP
- `mcp-from-openapi <url> <name>`: telecharge un OpenAPI et cree un stub MCP
- `mcp-register <name> <path>`: enregistre un serveur dans `/root/mcp/registry/registry.json`
- `mcp-dockerize <name>`: genere un Dockerfile et build l'image `mcp-<name>`

## Scripts bootstrap additionnels (`opt/bootstrap`)

Ces scripts ne sont pas appeles automatiquement par `n3xai-install`, mais sont fournis pour l'administration:

- `users.sh`
- lit `/etc/n3xai/env.conf`
- cree 2 comptes admin et les ajoute au groupe `sudo`
- `ssh-hardening.sh`
- modifie `sshd_config` (PermitRootLogin / PasswordAuthentication)
- redemarre `ssh`
- `postgresql.sh`
- installe PostgreSQL
- cree database, utilisateur, privileges depuis `env.conf`
- `docker-registry.sh`
- deploie un registre Docker prive (`registry:2`) sur le port `5000`

## Configuration

Fichier principal:

- `etc/n3xai/env.conf`

Variables importantes:

- PostgreSQL (`POSTGRE_*`)
- comptes admin (`ADMIN*_USER`, `ADMIN*_PASS`, `ADMIN*_EMAIL`)
- variables d'environnement MCP (`MCP_HOME`, `MCP_VENV`, `PATH`)

## Build et installation du package `.deb`

Depuis la racine du workspace parent:

```bash
cd /root
./n3xai-devops-codex/build.sh
sudo dpkg -i n3xai-devops-codex.deb
```

Puis lancer:

```bash
sudo n3xai-install
```

## Utilisation rapide MCP

```bash
# Creer un serveur MCP
create-mcp-server

# Lancer l'orchestrateur (si installe)
mcp-orchestrator

# Enregistrer un serveur
mcp-register myserver /root/mcp/servers/myserver/server.py
```

## Notes de securite (important avant usage public)

- Les valeurs dans `etc/n3xai/env.conf` sont maintenant des placeholders et doivent etre remplacees avant la production.
- Un template public est disponible dans `etc/n3xai/env.conf.example`.
- Il est fortement recommande d'injecter les secrets via variables d'environnement ou coffre de secrets.
- Plusieurs scripts supposent une execution `root` sur Ubuntu/Debian (APT/systemd).

## Limitations connues

- `ssh-hardening.sh` active `PasswordAuthentication yes`, ce qui peut etre contraire a un hardening strict.
- Les scripts ne sont pas pleinement idempotents (ex: liens symboliques deja existants).

## Licence

Ajouter une licence explicite (MIT, Apache-2.0, proprietaire, etc.) avant publication large.
