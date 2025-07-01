#!/bin/bash
set -e

crave run --no-patch -- "
  # 🔹 Step 1: Clean old manifests, soong, and keys
  rm -rf .repo/local_manifests
  rm -rf vendor/google/gms
  rm -rf vendor/gms
  
  # 🔹 Step 2: Repo init gamit ang InfinityX manifest
  repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs

  # 🔹 Step 3: Clone local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b evox15-bp2a .repo/local_manifests

  # Signingkey
  git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys &&
  cd vendor/evolution-priv/keys&&
  ./keys.sh
  # 🔹 Step 5: Write releasekey config
  echo 'PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/infinity-priv/keys/releasekey' > vendor/infinity-priv/keys/keys.mk

  # 🔹 Step 6: Remove Chrome from gms
  echo '➤ Removing Chrome...'
  sed -i '/Chrome.apk/s/^/# /' vendor/google/gms/proprietary-files.txt
  sed -i '/Chrome/s/^/# /' vendor/google/gms/gms-vendor.mk
  rm -rf vendor/gms/product/app/Chrome
  find vendor/gms -type f -iname \"Chrome.apk\" -exec rm -f {} \;
  echo '✅ Chrome removal complete.'

  # 🔹 Step 7: Sync full source
  /opt/crave/resync.sh

  # 🔹 Step 8: Setup environment and build
  . build/envsetup.sh
  lunch lineage_LG7n-bp2a-userdebug
  m evolution
"
