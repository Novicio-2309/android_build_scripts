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
  rm -rf vendor/lineage-priv/keys &&

  # 🔹 Step 2: Initialize repo
  repo init -u https://github.com/Project-Mist-OS/manifest -b vic --git-lfs &&

  # 🔹 Step 3: Clone your local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b mistOS-15-bp1a .repo/local_manifests &&

  # 🔹 Step 4: Create keys directory and copy crave_sign.sh
  mkdir -p vendor/lineage-priv/keys &&
  cp crave_sign.sh vendor/lineage-priv/keys/ &&
  chmod +x vendor/lineage-priv/keys/crave_sign.sh &&

  # 🔹 Step 5: Run crave_sign.sh to download and extract signing keys
  bash vendor/lineage-priv/keys/crave_sign.sh &&

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
  lunch lineage_LG7n-userdebug &&

  # 🔹 Step 10: Build the ROM
  mka bacon
"
