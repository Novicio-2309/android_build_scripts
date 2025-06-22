#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/PixelOS-AOSP/manifest

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "
rm -rf .repo/local_manifests &&
# Initialize repo with specified manifest
repo init -u https://github.com/ProjectPixelage/android_manifest.git -b 15 --git-lfs

# Clone local_manifests repository
git clone https://github.com/Novicio-2309/local_manifests.git -b pixelage-bp1a-pova4series .repo/local_manifests &&

# Sync the repositories
/opt/crave/resync.sh &&t


# Set up build environment
PIXELAGE_BUILD=LG7n &&
source build/envsetup.sh &&

# Lunch configuration
lunch pixelage_LG7n-bp1a-userdebug &&

# remove key folder
rm -rf vendor/voltage-priv/keys &&

# Build
croot &&
mka bacon
"

# Pull generated zip files
crave pull out/target/product/*/*.zip

# Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
# telegram-upload --to sdreleases out/target/product/*/*.zip
    
# Upload to Github Releases
# curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
# Clean up build artifacts (if needed)
# rm -rf out/target/product/*
