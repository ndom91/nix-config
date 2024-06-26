#!/usr/bin/env bash

CYAN='\033[1;36m'
NC='\033[0m'

appImageDir="/opt/appimages"
version="$1"
buildId="$2"

if [[ -z "$version" || -z "$buildId" ]]; then
  echo -e "[${CYAN}*${NC}] Usage: $0 <version> <buildId>"
  exit 1
fi

echo -e "[${CYAN}*${NC}] Downloading nightly release ${CYAN}$version-$buildId${NC}"

wget \
  -cqO "$appImageDir/git-butler-nightly_latest.tar.gz" \
  "https://releases.gitbutler.com/releases/nightly/$version-$buildId/linux/x86_64/git-butler-nightly_${version}_amd64.AppImage.tar.gz"

echo -e "[${CYAN}*${NC}] Extracting"

tar -xf "$appImageDir/git-butler-nightly_latest.tar.gz"

echo -e "[${CYAN}*${NC}] Cleaning up"

rm "$appImageDir/git-butler-nightly_latest.tar.gz"
mv "$appImageDir/git-butler-nightly_${version}_amd64.AppImage" "$appImageDir/git-butler-nightly_latest.AppImage"
