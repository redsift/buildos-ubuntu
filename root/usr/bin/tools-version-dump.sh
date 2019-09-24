#!/bin/sh

set -e

# NODE=$(node -v)
# NPM=$(npm -v)
JAVA=$(java -version)
MAVEN=$(mvn -version)

# echo "NodeJS ${NODE}"
# echo "NPM ${NPM}"
echo "$JAVA"
echo "$MAVEN"

/usr/bin/go-version-dump.sh
