#!/bin/bash

set -e

# Run inside foss.crave.io devspace, in the project folder
crave run --no-patch -- "
# Step 1: Clean up previous config and test keys
rm -rf .repo/local_manifests &&
rm -rf vendor/lineage-priv/keys &&

# Step 2: Initialize repo with specified manifest
repo init -u https://github.com/ProjectPixelage/android_manifest.git -b 15 --git-lfs &&

# Step 3: Clone your local_manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b pixelage-bp1a-pova4series .repo/local_manifests &&

# Step 4: Prepare keys folder
mkdir -p vendor/lineage-priv/keys &&

# Step 5: Download signing keys from PixelDrain
echo 'Downloading signing keys from PixelDrain...'
curl -L https://pixeldrain.com/api/file/VBFj5hBW/download -o signing-keys.tar.gz &&
tar -xvf signing-keys.tar.gz -C vendor/lineage-priv/keys &&
rm -f signing-keys.tar.gz &&

# Step 6: Sync the full source
/opt/crave/resync.sh &&

# Step 7: Set up environment
PIXELAGE_BUILD=LG7n &&
source build/envsetup.sh &&
lunch pixelage_LG7n-bp1a-userdebug &&

# Step 8: Start the build
mka bacon
"
