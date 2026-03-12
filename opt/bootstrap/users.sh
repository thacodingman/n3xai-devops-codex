#!/bin/bash

source /etc/n3xai/env.conf

echo "Creating admin users..."

useradd -m -s /bin/bash $ADMIN1_USER
echo "$ADMIN1_USER:$ADMIN1_PASS" | chpasswd
usermod -aG sudo $ADMIN1_USER

useradd -m -s /bin/bash $ADMIN2_USER
echo "$ADMIN2_USER:$ADMIN2_PASS" | chpasswd
usermod -aG sudo $ADMIN2_USER

echo "Users created."