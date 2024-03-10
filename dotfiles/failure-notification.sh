#!/usr/bin/env bash

error="$1"
notify-send "Failure" "$error" --icon=dialog-error
