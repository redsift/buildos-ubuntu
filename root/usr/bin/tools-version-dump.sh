#!/bin/sh

set -e

JAVA=$(java -version)
MAVEN=$(mvn -version)

echo "$JAVA"
echo "$MAVEN"

/usr/bin/go-version-dump.sh
# /usr/bin/node-version-dump.sh
