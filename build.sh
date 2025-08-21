#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&

# Manifest
git clone https://github.com/Novicio-2309/local_manifests.git -b infinity-16-bp2a .repo/local_manifests &&

#Setup environment and start build
. build/envsetup.sh &&
lunch infinity_LG7n-userdebug &&
m bacon
"
