#!/bin/bash
# TrollPadOS build helper — ho tro rootless & rootful
# Cach dung:
#   ./build.sh rootless   -> deb cho TrollStore/rootless bootstrap
#   ./build.sh rootful    -> deb cho jailbreak rootful (/var/jb cu)
set -e

SCHEME="${1:-rootless}"
export THEOS_PACKAGE_SCHEME="$SCHEME"

if [ ! -d "$THEOS" ]; then
  echo "[!] Chua dat THEOS. Export THEOS=/path/to/theos truoc khi chay."
  exit 1
fi

# Voi rootless, them prefix var/jb vao layout (Theos lam tu dong khi scheme=rootless)
make clean package FINALPACKAGE=1

echo ""
echo "Deb: $(ls -t packages/*.deb | head -n1)"
echo "Cai dat:"
if [ "$SCHEME" = "rootless" ]; then
  echo "  TrollStore: mo file deb bang TrollStore"
  echo "  Rootless Bootstrap (Dopamine/ellekit): import qua Sileo/Zebra"
else
  echo "  Jailbreak rootful (palera1n-legacy...): import qua Sileo"
fi
