#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf device/tecno/LH7n &&
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
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&
rm -rf out &&

# Local Manifest cloning
git clone https://github.com/Novicio-2309/local_manifests.git -b LH7n-infinity16 .repo/local_manifests &&

# Initialize Repo
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault &&

# Syncing repo
repo sync --force-sync &&

# Signingkey
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/infinity-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
lunch infinity_LH7n-userdebug &&
m bacon
"
