#!/bin/bash

set -e

# ✅ Check if crave_sign.sh exists in root
if [ ! -f crave_sign.sh ]; then
  echo "❌ Missing crave_sign.sh in root directory!"
  exit 1
fi

crave run --no-patch -- "
  # 🔹 Step 1: Clean previous config and test keys
  rm -rf .repo/local_manifests
  rm -rf vendor/lineage-priv/keys

  # 🔹 Step 2: Initialize Pixelage manifest
  repo init -u https://github.com/ProjectPixelage/android_manifest.git -b 15 --git-lfs

  # 🔹 Step 3: Clone local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b pixelage-bp1a-pova4series .repo/local_manifests

  # 🔹 Step 4: Prepare keys directory
  mkdir -p vendor/lineage-priv/keys
  cp crave_sign.sh vendor/lineage-priv/keys/
  chmod +x vendor/lineage-priv/keys/crave_sign.sh
  bash vendor/lineage-priv/keys/crave_sign.sh

  # 🔹 Step 5: Write releasekey path to keys.mk
  echo 'PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey' > vendor/lineage-priv/keys/keys.mk

  # 🔹 Step 6: Sync source
  /opt/crave/resync.sh

  # 🔹 Step 7: Set environment and lunch
  lunch pixelage_LG7n-bp1a-userdebug

  # 🔹 Step 8: Start the build
  mka bacon
"
