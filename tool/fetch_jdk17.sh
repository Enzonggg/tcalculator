#!/usr/bin/env bash
# Downloads Eclipse Temurin JDK 17 into .toolchain/ (gitignored) for Android builds.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/.toolchain"
ARCH="$(uname -m)"
case "$ARCH" in
  arm64) PLATFORM="mac/aarch64" ;;
  x86_64) PLATFORM="mac/x64" ;;
  *)
    echo "Unsupported arch: $ARCH" >&2
    exit 1
    ;;
esac
mkdir -p "$DEST"
TMP="$DEST/temurin17.tar.gz"
echo "Downloading Temurin 17 ($PLATFORM)..."
curl -fsSL -o "$TMP" "https://api.adoptium.net/v3/binary/latest/17/ga/${PLATFORM}/jdk/hotspot/normal/eclipse"
tar -xzf "$TMP" -C "$DEST"
rm "$TMP"
JAVA_HOME="$(find "$DEST" -path "*/Contents/Home/bin/java" -type f 2>/dev/null | head -1)"
JAVA_HOME="$(cd "$(dirname "$JAVA_HOME")/.." && pwd)"
echo "JDK 17 ready at:"
echo "  $JAVA_HOME"
echo ""
echo "Point Flutter at it (required for assembleRelease with AGP):"
echo "  flutter config --jdk-dir=\"$JAVA_HOME\""
echo ""
echo "Optional: add to android/local.properties (this file is gitignored):"
echo "  org.gradle.java.home=$JAVA_HOME"
