#!/usr/bin/env bash

set -eo pipefail

CYAN="\e[0;96m"
BLACK="\e[1;30m"
BOLDCYAN="\e[1;96m"
CYANBG="\e[46;1m"
RED="\e[0;91m"
NC="\e[0m"

RELEASE_TYPE=${1-nightly}

replace_first() {
  local string="$1"
  local search="$2"
  local replace="$3"
  echo "${string/$search/$replace}"
}

# Default URL to latest AppImage
URL=$(curl -sk "https://app.gitbutler.com/releases/$RELEASE_TYPE" | jq '.platforms."linux-x86_64".url' | sed 's|\"||g')

FILENAME=$(basename -s .tar.gz "$URL")

TARGET_DIR="/opt/appimages/"
TARBALL_FILENAME=$(basename "$URL")
APPIMAGE_FILENAME=$(basename -s .tar.gz "$URL" | sed 's| |_|g')

echo -e "\n  ${BOLDCYAN}⧑${NC}  ${CYANBG}${BLACK} GitButler ${NC} Downloader\n"

cd "$TARGET_DIR" || return

if [ -f "$APPIMAGE_FILENAME" ]; then
  echo -e "[${CYAN}*${NC}] You're already on the latest version - ${CYAN}$FILENAME${NC}"
  echo -e "[${CYAN}*${NC}] Exiting"
  exit 0
fi

echo -e "[${CYAN}*${NC}] Downloading ${CYAN}$TARBALL_FILENAME${NC}"

if ! wget --quiet "$URL"; then
  echo -e "Download failed - ${RED}$URL${NC}"
  exit 1
fi

echo -e "[${CYAN}*${NC}] Extracting ${CYAN}$TARBALL_FILENAME${NC}"

TAR_CONTENTS=$(tar --list --file "$TARBALL_FILENAME")

tar -xf "$TARBALL_FILENAME"
mv "$TAR_CONTENTS" "$APPIMAGE_FILENAME"

echo -e "[${CYAN}*${NC}] Cleaning up"

rm -f /opt/appimages/git-butler-nightly_latest.AppImage
rm -f -- *.tar.gz

echo -e "[${CYAN}*${NC}] Linking latest AppImage"

ln -s "$APPIMAGE_FILENAME" git-butler-nightly_latest.AppImage

echo -e "[${CYAN}*${NC}] Complete 🎉"
