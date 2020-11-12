#!/bin/sh

set -e

JAVA=$(java -version)
MAVEN=$(mvn -version)

echo "$JAVA"
echo "$MAVEN"
