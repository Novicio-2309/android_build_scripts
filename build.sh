#!/bin/bash

set -e

crave run --no-patch -- "
  # Step 1: Clean up old manifests and keys
  rm -rf .repo/local_manifests &&
  rm -rf vendor/mist/signing/keys &&

  # Step 2: Initialize repo with specified manifest
  repo init -u https://github.com/Project-Mist-OS/manifest -b vic --git-lfs &&

  # Step 3: Clone your local_manifests
  git clone https://github.com/Novicio-2309/local_manifests.git .repo/local_manifests &&

  # Step 4: Recreate signing key folder
  mkdir -p vendor/mist/signing/keys &&

  # Step 5: Attempt to fetch signing keys from Backblaze
  echo '🔐 Attempting to download signing keys from Backblaze...'
  if ! bash vendor/mist/signing/keys/crave_sign.sh; then
    echo '⚠️ Backblaze failed. Falling back to PixelDrain...'
    curl -L https://pixeldrain.com/api/file/VBFj5hBW/download -o signing-keys.tar.gz &&
    tar -xvf signing-keys.tar.gz -C vendor/mist/signing/keys &&
    rm -f signing-keys.tar.gz
  fi &&

  # Step 6: Overwrite keys.mk if it exists
  if [ -f vendor/mist/signing/keys/keys.mk ]; then
    echo '📄 Overwriting keys.mk to set releasekey...'
    echo \"PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/mist/signing/keys/releasekey\" > vendor/mist/signing/keys/keys.mk
  fi &&

  # Step 7: Sync the full source
  /opt/crave/resync.sh &&

  # Step 8: Replace default build/soong with patched version
  echo '🔧 Replacing build/soong with patched version from your GitHub fork...'
  rm -rf build/soong &&
  git clone https://github.com/Novicio-2309/android_build_soong.git -b patched-15 build/soong &&

  # Step 9: Set up build environment
  source build/envsetup.sh &&
  mistify LG7n userdebug &&
  mka target-files-package otatools &&

  # Step 10: Start the build
  mist b
"
