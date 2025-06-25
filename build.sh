#!/bin/bash

set -e

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
# Remove existing local_manifests
rm -rf .repo/local_manifests &&
rm -rf build/soong &&
rm -rf vendor/lineage-priv/keys &&

# Initialize repo with specified manifest
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault &&

# Clone your local_manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b infinityX-15-bp1a .repo/local_manifests &&

#Signingkey for infinity
git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys &&
cd vendor/infinity-priv/keys &&
./keys.sh &&

# Start repo sync
/opt/crave/resync.sh &&

# Set up environment
. build/envsetup.sh &&
lunch infinity_LG7n-userdebug &&

# Start the build
mka bacon
"
