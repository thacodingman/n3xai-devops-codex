#!/bin/bash
set -e

echo "Installing MCP tools..."

apt update

apt install -y \
python3 \
python3-full \
python3-pip \
python3-venv \
jq \
git \
curl

BASE=/root/mcp
VENV=$BASE/venv

echo "Creating MCP directory structure..."

mkdir -p $BASE/{servers,logs,registry,runtime,templates,build}
mkdir -p $BASE/servers/{docker,aws,aapanel,dns}

echo "Creating Python virtual environment..."

python3 -m venv $VENV

source $VENV/bin/activate

echo "Installing MCP Python dependencies..."

pip install --upgrade pip

pip install \
fastapi \
uvicorn \
pydantic \
requests \
pyyaml \
watchdog

deactivate

echo "MCP tools installed successfully."