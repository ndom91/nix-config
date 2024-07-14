#!/usr/bin/env bash
# See: https://github.com/wimpysworld/nix-config/blob/main/home-manager/_mixins/scripts/captive-portal/default.nix

xdg-open http://"$(ip --oneline route get 1.1.1.1 | awk '{print $3}')"
