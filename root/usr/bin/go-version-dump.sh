#!/bin/sh

set -e

GV=$(go version)
DEP=$(dep version)
GLIDE=$(glide --version)

echo "Go ${GV}"
echo "$DEP"
echo "$GLIDE"
