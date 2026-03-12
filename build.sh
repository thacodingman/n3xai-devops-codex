#!/bin/bash

PKG=n3xai-devops-codex

dpkg-deb --build $PKG

echo "Package built:"
echo "$PKG.deb"