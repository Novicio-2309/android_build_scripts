#!/bin/bash
set -e

# ✅ Check kung may crave_sign.sh sa root directory
if [ ! -f crave_sign.sh ]; then
  echo "❌ Missing crave_sign.sh in root directory!"
  exit 1
fi

crave run --no-patch -- "
  # 🔹 Step 1: Clean old manifests, soong, and keys
  rm -rf .repo/local_manifests
  rm -rf build/soong
  rm -rf vendor/infinity-priv/keys

  # 🔹 Step 2: Repo init gamit ang InfinityX manifest
  repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault

  # 🔹 Step 3: Clone local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b infinityX-15-bp1a .repo/local_manifests

  # 🔹 Step 4: Create signing key directory and run crave_sign.sh
  mkdir -p vendor/infinity-priv/keys
  cp crave_sign.sh vendor/infinity-priv/keys/
  chmod +x vendor/infinity-priv/keys/crave_sign.sh
  bash vendor/infinity-priv/keys/crave_sign.sh

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
  lunch infinity_LG7n-userdebug
  mka bacon
"
