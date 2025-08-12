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
rm -rf vendor/lineage-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&

#Repo init
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b infinity-16-bp2a .repo/local_manifests &&

#Sync the full source
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) &&

#signing keys and run setup
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/infinity-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
lunch infinity_LG7n-userdebug &&
m bacon
"
