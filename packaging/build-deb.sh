#!/usr/bin/env bash
# Build a .deb for sysz with declared fzf/bash dependencies.
# Usage: ./packaging/build-deb.sh [output-dir]
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

VERSION=$(tr -d '[:space:]' <VERSION)
PKG_NAME=sysz
ARCH=all
OUT_DIR=${1:-"$ROOT/dist"}
STAGE=$(mktemp -d "${TMPDIR:-/tmp}/sysz-deb.XXXXXX")
trap 'rm -rf "$STAGE"' EXIT

DEB_ROOT="$STAGE/${PKG_NAME}_${VERSION}_${ARCH}"
mkdir -p "$DEB_ROOT/DEBIAN" "$DEB_ROOT/usr/bin" "$DEB_ROOT/usr/share/doc/${PKG_NAME}"

install -m755 sysz "$DEB_ROOT/usr/bin/sysz"

# Sync embedded version stamp with VERSION file
sed -i -e "s/^SYSZ_VERSION=.*/SYSZ_VERSION=${VERSION}/" "$DEB_ROOT/usr/bin/sysz"

install -m644 UNLICENSE "$DEB_ROOT/usr/share/doc/${PKG_NAME}/copyright"
install -m644 CHANGELOG.md "$DEB_ROOT/usr/share/doc/${PKG_NAME}/changelog"
gzip -9n -f "$DEB_ROOT/usr/share/doc/${PKG_NAME}/changelog"
install -m644 README.md "$DEB_ROOT/usr/share/doc/${PKG_NAME}/README.md"

# Installed-Size is in KiB
INSTALLED_SIZE=$(du -sk "$DEB_ROOT" | cut -f1)

cat >"$DEB_ROOT/DEBIAN/control" <<EOF
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: bash (>= 4.3), fzf (>= 0.27.1)
Maintainer: Rod <rod@overflow.biz>
Installed-Size: ${INSTALLED_SIZE}
Homepage: https://github.com/rorph/sysz
Description: fzf terminal UI for systemctl
 Interactive fuzzy-finder frontend for systemctl and journalctl.
 Supports system and user units, multi-select, state filters,
 journal follow, and back-navigation in the command picker.
EOF

mkdir -p "$OUT_DIR"
DEB_PATH="$OUT_DIR/${PKG_NAME}_${VERSION}_${ARCH}.deb"
dpkg-deb --root-owner-group --build "$DEB_ROOT" "$DEB_PATH" >/dev/null

echo "Built: $DEB_PATH"
dpkg-deb -I "$DEB_PATH"
echo "---"
dpkg-deb -c "$DEB_PATH"
