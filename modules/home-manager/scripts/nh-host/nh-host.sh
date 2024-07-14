#!/usr/bin/env bash
# See: https://github.com/wimpysworld/nix-config/blob/main/nixos/_mixins/scripts/nh-host/nh-host.sh

function usage() {
  echo "Usage: ${0} {build|switch}"
  exit 1
}

# Validate input argument
if [ "$#" -ne 1 ]; then
  usage
fi

if [ "${1}" != "build" ] && [ "${1}" != "switch" ]; then
  echo "Invalid argument: ${1}"
  usage
fi

all_cores=$(nproc)
build_cores=$(printf "%.0f" "$(echo "${all_cores} * 0.75" | bc)")
echo "${1^}ing NixOS ❄️ with ${build_cores} cores"
nh os "${1}" "${HOME}/Zero/nix-config/" -- --cores "${build_cores}"
