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
APPIMAGE="739FB9"
ACCENT="b44422"

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

# 2. I2PSnark Download (github logo, accent color)
curl -sL "https://img.shields.io/badge/I2PSnark-Download-${ACCENT}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/i2psnark-badge.svg"

# 3. Javadocs Download (github logo, accent color)
curl -sL "https://img.shields.io/badge/Javadocs-Download-${ACCENT}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/javadocs-badge.svg"

# 4. Installer Download (github logo, accent color)
curl -sL "https://img.shields.io/badge/Installer-v${VERSION}-${ACCENT}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/installer-badge.svg"

# 5. Update zip Download (github logo, accent color)
curl -sL "https://img.shields.io/badge/Update%20zip-v${VERSION}-${ACCENT}?logo=github&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/update-badge.svg"

# 6. AppImage Guide (appimage logo white, blue)
curl -sL "https://img.shields.io/badge/AppImage-Guide-${BLUE}?logo=appimage&logoColor=white&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/appimage-badge.svg"

# 5. AppImage Guide (appimage logo white, blue)
curl -sL "https://img.shields.io/badge/AppImage-Guide-${BLUE}?logo=appimage&logoColor=white&style=${STYLE}&height=${HEIGHT}" > "${SCRIPT_DIR}/appimage-badge.svg"

echo "Done! Badges saved to ${SCRIPT_DIR}"