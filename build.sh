#!/bin/bash

PKG=n3xai-devops

dpkg-deb --build $PKG

echo "Package built:"
echo "$PKG.deb"