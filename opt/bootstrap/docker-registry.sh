#!/bin/bash

echo "Deploying private Docker registry..."

docker run -d \
-p 5000:5000 \
--restart always \
--name registry \
registry:2

echo "Registry running on port 5000"