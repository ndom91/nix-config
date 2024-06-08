#!/usr/bin/env bash

set -xe

if [[ -z $1 ]]; then
  echo "Domain required"
  exit 0
fi

certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.config/cf_token.ini \
  --dns-cloudflare-propagation-seconds 60 \
  -d $1
