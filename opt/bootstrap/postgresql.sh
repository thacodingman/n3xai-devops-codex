#!/bin/bash

source /etc/n3xai/env.conf

echo "Installing PostgreSQL..."

apt install -y postgresql postgresql-contrib

sudo -u postgres psql <<EOF

CREATE DATABASE $POSTGRE_NAME;

CREATE USER $POSTGRE_USER WITH PASSWORD '$POSTGRE_PASS';

GRANT ALL PRIVILEGES ON DATABASE $POSTGRE_NAME TO $POSTGRE_USER;

EOF

echo "PostgreSQL configured."