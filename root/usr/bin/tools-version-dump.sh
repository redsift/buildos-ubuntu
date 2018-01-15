#!/bin/sh

set -e

GV=$(go version)
NODE=$(node -v)
NPM=$(npm -v)
JAVA=$(java -version)
MAVERN=$(mvn -version)
GLIDE=$(glide --version)

echo "NodeJS ${NODE}"
echo "NPM ${NPM}"
echo "$JAVA"
echo "$MAVERN"

/usr/bin/go-version-dump.sh
