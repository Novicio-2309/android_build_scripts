#!/bin/bash

set -e

crave run --no-patch -- "
  rm -rf .repo/local_manifests &&

  repo init -u https://github.com/ProjectPixelage/android_manifest.git -b 15 --git-lfs &&

  git clone https://github.com/Novicio-2309/local_manifests.git -b pixelage-bp1a-pova4series .repo/local_manifests &&

  rm -rf vendor/lineage-priv/keys &&

  /opt/crave/resync.sh &&

  PIXELAGE_BUILD=LG7n &&
  source build/envsetup.sh &&

  lunch pixelage_LG7n-bp1a-userdebug &&

  mka target-files-package otatools &&

  /opt/crave/crave_sign.sh &&

  mka bacon
"

# Pull ROM ZIP and images
crave pull out/target/product/*/*.zip
crave pull out/target/product/*/*.img
