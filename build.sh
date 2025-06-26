#!/bin/bash

set -e

# ✅ Check kung may crave_sign.sh sa kasalukuyang folder
if [ ! -f crave_sign.sh ]; then
  echo "❌ Missing crave_sign.sh in root directory!"
  exit 1
fi

crave run --no-patch -- "
  # 🔹 Step 1: Clean old manifests and keys
  rm -rf .repo/local_manifests &&
  rm -rf vendor/mist/signing/keys &&

  # 🔹 Step 2: Initialize repo
  repo init -u https://github.com/Project-Mist-OS/manifest -b vic --git-lfs &&

  # 🔹 Step 3: Clone your local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b mistOS-15-bp1a .repo/local_manifests &&

  # 🔹 Step 4: Create keys directory and copy crave_sign.sh
  mkdir -p vendor/mist/signing/keys &&
  cp crave_sign.sh vendor/mist/signing/keys/ &&
  chmod +x vendor/mist/signing/keys/crave_sign.sh &&

  # 🔹 Step 5: Run crave_sign.sh to download and extract signing keys
  bash vendor/mist/signing/keys/crave_sign.sh || (
    echo '⚠️ Backblaze failed. Falling back to PixelDrain...' &&
    curl -L https://pixeldrain.com/api/file/VBFj5hBW/download -o signing-keys.tar.gz &&
    mkdir -p vendor/mist/signing/temp_keys &&
    tar -xvf signing-keys.tar.gz -C vendor/mist/signing/temp_keys &&
    rm -f signing-keys.tar.gz &&
    SUBDIR=\$(find vendor/mist/signing/temp_keys -mindepth 1 -maxdepth 1 -type d | head -n 1) &&
    cp -r \$SUBDIR/* vendor/mist/signing/keys/ &&
    rm -rf vendor/mist/signing/temp_keys &&
    echo 'PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/mist/signing/keys/releasekey' > vendor/mist/signing/keys/keys.mk
  ) &&

  # 🔹 Step 6: Sync the full source
  /opt/crave/resync.sh &&

  # 🔹 Step 7: Remove Chrome from vendor/google and vendor/gms
  echo '🧹 Removing Chrome references...' &&
  for dir in vendor/google vendor/gms; do
    if [ -d \"\$dir\" ]; then
      echo \"➡️ Checking \$dir...\"
      grep -Ril 'chrome' \"\$dir\" | while read f; do
        sed -i '/[Cc]hrome/d' \"\$f\"
      done
      find \"\$dir\" -type f -iname '*chrome*.apk' -exec rm -f {} \;
    fi
  done &&
  echo '✅ Chrome cleanup finished.' &&

  # 🔹 Step 8: Replace build/soong with patched version
  echo '🔧 Replacing build/soong with patched version from your GitHub fork...'
  rm -rf build/soong &&
  git clone https://github.com/Novicio-2309/android_build_soong.git -b patched-15 build/soong &&

  # 🔹 Step 9: Set up build environment and target
  source build/envsetup.sh &&
  mistify LG7n userdebug &&

  # 🔹 Step 10: Build the ROM
  mist b
"
