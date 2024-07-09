#!/usr/bin/env bash

# set -x
CYAN="\e[0;96m"
BOLDCYAN="\e[1;96m"
CYANBG="\e[46;1m"
RED="\e[0;91m"
NC="\e[0m"

# Default URL to latest AppImage
URL=$(curl -sk https://app.gitbutler.com/releases/nightly | jq '.platforms."linux-x86_64".url' | sed 's|\"||g')

# Allow overriding via first argument
if [[ $1 ]]; then
 URL="$1"
fi

TARGET_DIR="/opt/appimages/"
TARBALL_FILENAME=$(basename "$URL")
APPIMAGE_FILENAME=$(basename --suffix=".tar.gz"  "$URL")

echo -e "\n  ${BOLDCYAN}⧑${NC}  ${CYANBG} GitButler ${NC} Nightly Downloader\n"

cd "$TARGET_DIR" || return

echo -e "[${CYAN}*${NC}] Downloading ${CYAN}$TARBALL_FILENAME${NC}"

if ! wget --quiet "$URL"; then
  echo -e "Download failed - ${RED}$URL${NC}"
  exit 1
fi

echo -e "[${CYAN}*${NC}] Extracting ${CYAN}$TARBALL_FILENAME${NC}"

tar -xf "$TARBALL_FILENAME"

echo -e "[${CYAN}*${NC}] Cleaning up"

rm -f /opt/appimages/git-butler-nightly_latest.AppImage
rm -f -- *.tar.gz

echo -e "[${CYAN}*${NC}] Linking latest AppImage"

ln -s "$APPIMAGE_FILENAME" git-butler-nightly_latest.AppImage

echo -e "[${CYAN}*${NC}] Complete 🎉"
