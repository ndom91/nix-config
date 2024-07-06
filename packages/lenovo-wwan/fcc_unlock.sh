#!/usr/bin/env bash

set -e 

# SPDX-License-Identifier: CC0-1.0
# 2024 Stoica Floris <floris@nusunt.eu>
# 2024 Modified by Bohdan Tkachenko <bohdan@tkachenko.dev>
#
# Lenovo-shipped XMM7560 (8086:7560) FCC unlock

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
    # logger -t ModemManager -p info "<info> $1"
}

error() {
  echo "Err: $1"
    logger -t ModemManager -p error "<error> $1"
}

reverseWithLittleEndian() {
    num="$1"
    printf "%x" $(("0x${num:6:2}${num:4:2}${num:2:2}${num:0:2}"))
}

VENDOR_ID_HASH="bb23be7f"

for i in {1..9}; do
    log "Requesting challenge from WWAN modem (attempt #${i})"
    RAW_CHALLENGE=$(at_command "at+gtfcclockgen")
    CHALLENGE=$(echo "$RAW_CHALLENGE" | grep -o '0x[0-9a-fA-F]\+' | awk '{print $1}')

    if [ -n "$CHALLENGE" ]; then
        log "Got challenge from modem: $CHALLENGE"
        HEX_CHALLENGE=$(printf "%08x" "$CHALLENGE")
        REVERSE_HEX_CHALLENGE=$(reverseWithLittleEndian "${HEX_CHALLENGE}")
        COMBINED_CHALLENGE="${REVERSE_HEX_CHALLENGE}${VENDOR_ID_HASH}"
        RESPONSE_HASH=$(printf "%s" "$COMBINED_CHALLENGE" | xxd -r -p | sha256sum | cut -d ' ' -f 1)
        TRUNCATED_RESPONSE=$(printf "%.8s" "${RESPONSE_HASH}")
        REVERSED_RESPONSE=$(reverseWithLittleEndian "$TRUNCATED_RESPONSE")
        RESPONSE=$(printf "%d" "0x${REVERSED_RESPONSE}")

        log "Sending hash modem: $RESPONSE"
        UNLOCK_RESPONSE=$(at_command "at+gtfcclockver=$RESPONSE")
        log "at+gtfcclockver response = $UNLOCK_RESPONSE"
        UNLOCK_RESPONSE=$(at_command "at+gtfcclockmodeunlock")
        log "at+gtfcclockmodeunlock response = $UNLOCK_RESPONSE"
        UNLOCK_RESPONSE=$(at_command "at+cfun=1")
        log "at+cfun response = $UNLOCK_RESPONSE"
        UNLOCK_RESPONSE=$(at_command "at+gtfcclockstate")
        log "at+gtfcclockstate response = $UNLOCK_RESPONSE"
        UNLOCK_RESPONSE=$(echo "$UNLOCK_RESPONSE" | tr -d '\r')

        if [ "$UNLOCK_RESPONSE" = "1" ] || [ "$UNLOCK_RESPONSE" = "OK" ]; then
            XDNS_RESPONSE=$(at_command "at+xdns=0,1")
            log "at+xdns response: ${XDNS_RESPONSE}"
        fi

        if [ "$UNLOCK_RESPONSE" = "1" ]; then
            log "FCC was unlocked previously"
            exit 0
        fi

        if [ "$UNLOCK_RESPONSE" = "OK" ]; then
            log "FCC unlock success"
            exit 0
        else
            error "Unlock failed. Got response: $UNLOCK_RESPONSE"
        fi
    else
        error "Failed to obtain FCC challenge. Got: ${RAW_CHALLENGE}"
    fi

    sleep 0.5
done

exit 2
