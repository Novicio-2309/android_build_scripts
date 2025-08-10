#!/bin/bash
set -e

crave run --no-patch -- "
#Repo init
repo init -u https://github.com/Project-Mist-OS/manifest.git -b 16 --git-lfs &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b mistOS16-Bp2a .repo/local_manifests && 

#signing keys and run setup
https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys && 
./keys.sh && \
popd && \

#Sync the full source
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all) &&

#Setup environment and start build
  . build/envsetup.sh &&
mistify LG7n userdebug &&
mist b
"
