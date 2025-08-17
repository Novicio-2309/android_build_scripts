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
rm -rf vendor/JamesDSP &&
rm -rf hardware/mediatek &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/infinity-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b mistOS16-Bp2a .repo/local_manifests &&

#Repo init
repo init -u https://github.com/CherishOS/android_manifest.git -b sixteen &&

#Sync the full source
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags &&

#signing keys and run setup
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/cherish-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
brunch LG7n
"
