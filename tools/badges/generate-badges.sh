#!/bin/bash
# Badge Generator Script
# Generates I2P+ badges using shields.io

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
BLUE="0078d4"
GREEN="2ecc71"
ORANGE="e67e22"
PURPLE="8e44ad"
GREY="555"

# Common parameters
STYLE="flat"
HEIGHT="20"

# Get version from CoreVersion.java
VERSION_FILE="${PROJECT_ROOT}/core/java/src/net/i2p/CoreVersion.java"
if [ -f "$VERSION_FILE" ]; then
    VERSION=$(grep 'public static final String VERSION =' "$VERSION_FILE" | sed 's/.*"\(.*\)".*/\1/')
else
    VERSION="unknown"
fi

echo "Generating badges for I2P+ v${VERSION}..."

# 1. Docker badge (docker logo)
curl -sL "https://img.shields.io/badge/Docker-Guide-${BLUE}?logo=docker&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/docker-badge.svg"

# 2. I2PSnark Download (github logo)
curl -sL "https://img.shields.io/badge/I2PSnark-v${VERSION}-${PURPLE}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/i2psnark-badge.svg"

# 3. Javadocs Download (github logo)
curl -sL "https://img.shields.io/badge/Javadocs-v${VERSION}-${ORANGE}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/javadocs-badge.svg"

# 4. Update zip Download (github logo)
curl -sL "https://img.shields.io/badge/Update%20zip-v${VERSION}-${GREEN}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/update-badge.svg"

echo "Done! Badges saved to ${SCRIPT_DIR}"