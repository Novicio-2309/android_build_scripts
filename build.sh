#!/bin/bash

set -e

crave run --no-patch -- "
  rm -rf .repo/local_manifests &&
  rm -rf vendor/lineage-priv/keys &&
  
# Step 2: Initialize repo with specified manifest
  repo init -u https://github.com/Project-Mist-OS/manifest -b vic --git-lfs &&
  
# Step 3: Clone your local_manifests
  git clone https://github.com/Novicio-2309/local_manifests.git .repo/local_manifests &&

  # Step 4: Prepare keys folder
mkdir -p vendor/mist/signing/keys &&

  # Step 5: Download signing keys from PixelDrain
echo 'Downloading signing keys from PixelDrain...'
curl -L https://pixeldrain.com/api/file/VBFj5hBW/download -o signing-keys.tar.gz &&
tar -xvf signing-keys.tar.gz -C vendor/mist/signing/keys &&
rm -f signing-keys.tar.gz &&

# Step 6: Sync the full source
  /opt/crave/resync.sh &&
  
# Step 7: Set up environment
  source build/envsetup.sh &&
  mistify LG7n userdebug &&
  mka target-files-package otatools &&

# Step 8: Start the build
  mist b 
"
