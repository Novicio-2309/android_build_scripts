#!/bin/bash

set -e

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
# Remove existing local_manifests
rm -rf .repo/local_manifests &&

# Initialize repo with specified manifest
repo init -u https://github.com/ProjectPixelage/android_manifest.git -b 15 --git-lfs &&

# Clone your local_manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b pixelage-bp1a-pova4series .repo/local_manifests &&

# Remove test keys (optional if you want to avoid testkey conflicts)
rm -rf vendor/lineage-priv/keys &&

# Download and extract your signing keys from PixelDrain
curl -L -o signing-keys.tar.gz https://pixeldrain.com/api/file/VBFj5hBW &&
tar -xvzf signing-keys.tar.gz &&

# Start repo sync
/opt/crave/resync.sh &&

# Set up environment
PIXELAGE_BUILD=LG7n &&
source build/envsetup.sh &&
lunch pixelage_LG7n-bp1a-userdebug &&

# Start the build
mka bacon
"

# Pull output files
crave pull out/target/product/*/*.zip
crave pull out/target/product/*/*.img
