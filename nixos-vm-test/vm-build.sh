#!/usr/bin/env bash

nixos-rebuild build-vm-with-bootloader -I ./configuration.nix --show-trace --max-jobs 4
