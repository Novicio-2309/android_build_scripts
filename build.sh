#!/bin/bash
set -e

crave run --no-patch -- "
repo sync --force-sync &&

# Clean only target outputs (not full clean, safe for Crave)
rm -rf out/target out/soong &&

# Setup environment
. build/envsetup.sh &&

# Lunch your device
lunch lineage_LG7n-bp2a-userdebug &&

# Start build
m lunaris
"
