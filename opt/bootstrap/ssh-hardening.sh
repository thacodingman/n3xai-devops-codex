#!/bin/bash

echo "Hardening SSH..."

sed -i 's/#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

systemctl restart ssh

echo "SSH hardened."