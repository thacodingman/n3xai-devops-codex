#!/bin/bash

echo "Updating system..."

apt update
apt upgrade -y

apt install -y \
curl \
wget \
git \
jq \
unzip \
build-essential \
software-properties-common \
apt-transport-https \
ca-certificates \
lsb-release \
gnupg

echo "Base system installed."