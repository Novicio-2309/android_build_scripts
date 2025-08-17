#!/bin/bash
set -e

crave run --no-patch -- "
# Remove old local manifests
rm -rf .repo/local_manifests &&

# Clone updated local manifest
git clone https://github.com/Novicio-2309/local_manifests.git -b cherishOS-16 .repo/local_manifests &&

# Sync sources with new manifest
repo sync -c -j\$(nproc --all) --force-sync --no-clone-bundle --no-tags &&

# Setup environment and start build
. build/envsetup.sh &&
brunch cherish_LG7n
"
