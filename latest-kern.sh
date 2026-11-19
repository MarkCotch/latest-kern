#!/usr/bin/env bash

# latest-kern (c)2026 Mark Coccimiglio.

_VERSION='0.0.1'
_RELEASE=2026-11-19

set -euo pipefail

RUNNING_KERNEL=$(uname -r)

# Find all vmlinuz images in /boot, strip the 'vmlinuz-' prefix,
# ignore rescue/debug kernels, and sort by version
LATEST_KERNEL=$(find /boot -maxdepth 1 -name 'vmlinuz-*' ! -name '*rescue*' ! -name '*kdump*' \
    | sed 's|^/boot/vmlinuz-||' \
    | sort -V \
    | tail -n 1)

if [[ -z "$LATEST_KERNEL" ]]; then
    echo "ERROR: Could not detect any installed kernels in /boot." >&2
    exit 2
fi

echo "Running kernel : $RUNNING_KERNEL"
echo "Latest installed: $LATEST_KERNEL"

if [[ "$RUNNING_KERNEL" == "$LATEST_KERNEL" ]]; then
    echo "STATUS: OK (Running the latest installed kernel)"
    exit 0
else
    echo "STATUS: REBOOT REQUIRED (Newer kernel is installed)"
    exit 1
fi

