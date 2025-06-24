#!/bin/bash

set -e

crave run --no-patch -- "
  rm -rf .repo/local_manifests &&

  repo init -u https://github.com/Project-Mist-OS/manifest -b vic --git-lfs &&

  git clone https://github.com/Novicio-2309/local_manifests.git .repo/local_manifests &&

  rm -rf vendor/lineage-priv/keys &&

  /opt/crave/resync.sh &&

  PIXELAGE_BUILD=LG7n &&
  source build/envsetup.sh &&

  mistify LG7n userdebug &&

  mka target-files-package otatools &&

  /opt/crave/crave_sign.sh &&

  mist b 
"

# Pull ROM ZIP and images
crave pull out/target/product/*/*.zip
crave pull out/target/product/*/*.img
