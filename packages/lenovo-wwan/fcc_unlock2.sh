#!/usr/bin/env bash

# SPDX-License-Identifier: CC0-1.0
# 2023 Thilo-Alexander Ginkel <thilo@ginkel.com>
#
# Lenovo-shipped Fibocom FM350-GL (14c3:4d75) FCC unlock

if [[ "$FCC_UNLOCK_DEBUG_LOG" == '1' ]]; then
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>>/var/log/mm-fm350-fcc.log 2>&1
fi

# require program name and at least 2 arguments
[ $# -lt 2 ] && exit 1

# first argument is DBus path, not needed here
shift

# second and next arguments are control port names
for PORT in "$@"; do
  # match port type in Linux 5.14 and newer
  grep -q AT "/sys/class/wwan/$PORT/type" 2>/dev/null && {
    AT_PORT=$PORT
    break
  }
  # match port name in Linux 5.13
  echo "$PORT" | grep -q AT && {
    AT_PORT=$PORT
    break
  }
done

# fail if no AT port exposed
[ -n "$AT_PORT" ] || exit 2

DEVICE=/dev/${AT_PORT}

at_command() {
  exec 99<>"$DEVICE"
  echo -e "$1\r" >&99
  read -r answer <&99
  read -r answer <&99
  echo "$answer"
  exec 99>&-
}

log() {
  echo "$1"
}

error() {
  echo "$1" >&2
}

# AT+QCFG=“usbcfg”,0x2C7C,0x0801,1,1,1,1,1,1,0
CMD="AT+QCFG=\"usbcfg\",0x2C7C,0x0125,1,1,1,1,1,1,0"
# CMD="AT+CFUN=1"
echo "CMD: $CMD; DEVICE: $DEVICE"
RAW_CHALLENGE=$(at_command "$CMD")
echo -e "\nInitial Resp: $RAW_CHALLENGE\n"

# exit 1

# VENDOR_ID_HASH="3df8c719"
VENDOR_ID_HASH="2c7c0801"

for i in {1..9}; do
  log "Requesting challenge from WWAN modem (attempt #${i})"
  RAW_CHALLENGE=$(at_command "at+gtfcclockgen")
  echo "RAW: $RAW_CHALLENGE"
  CHALLENGE=$(echo "$RAW_CHALLENGE" | grep -o '0x[0-9a-fA-F]\+' | awk '{print $1}')

  if [ -n "$CHALLENGE" ]; then
    log "Got challenge from modem: $CHALLENGE"
    HEX_CHALLENGE=$(printf "%08x" "$CHALLENGE")
    COMBINED_CHALLENGE="${HEX_CHALLENGE}$(printf "%.8s" "${VENDOR_ID_HASH}")"
    RESPONSE_HASH=$(echo "$COMBINED_CHALLENGE" | xxd -r -p | sha256sum | cut -d ' ' -f 1)
    TRUNCATED_RESPONSE=$(printf "%.8s" "$RESPONSE_HASH")
    RESPONSE=$(printf "%d" "0x$TRUNCATED_RESPONSE")

    log "Sending response to WWAN modem: $RESPONSE"
    UNLOCK_RESPONSE=$(at_command "at+gtfcclockver=$RESPONSE")

    if [[ "$UNLOCK_RESPONSE" == "+GTFCCLOCKVER:"* ]]; then
      UNLOCK_RESULT=$(echo "$UNLOCK_RESPONSE" | grep -o '[0-9]\+')
      if [[ "$UNLOCK_RESULT" == "1" ]]; then
        log "FCC unlock succeeded"
        exit 0
      else
        error "FCC unlock failed. Got result: $UNLOCK_RESULT"
      fi
    else
      error "Unlock failed. Got response: $UNLOCK_RESPONSE"
    fi
  else
    error "Failed to obtain FCC challenge. Got: ${RAW_CHALLENGE}"
  fi

  sleep 0.5
done

exit 2
