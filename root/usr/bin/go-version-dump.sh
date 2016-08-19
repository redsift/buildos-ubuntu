#!/bin/sh

set -e

GV=$(go version)
GLIDE=$(glide --version)

echo "Go ${GV}"
echo "$GLIDE"
