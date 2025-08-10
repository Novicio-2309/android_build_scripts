#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf device/tecno/LG7n &&
rm -rf device/tecno/mt6789-common &&
rm -rf device/tecno/LG7n-kernel &&
rm -rf vendor/tecno/LG7n &&
rm -rf vendor/tecno/mt6789-common &&
rm -rf vendor/sony/dolby &&
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf hardware/mediatek &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/lineage-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&

#Repo init
repo init -u https://github.com/Project-Mist-OS/manifest.git -b 16 --git-lfs &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b mistOS16-Bp2a .repo/local_manifests && 

#signing keys and run setup
https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys && 
./keys.sh &&
popd &&

#Sync the full source
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all) &&

#Setup environment and start build
. build/envsetup.sh &&
mistify LG7n userdebug &&
mist b
"
