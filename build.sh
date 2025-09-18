#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf device/tecno/LH7n &&
rm -rf device/tecno/LG7n &&
rm -rf device/tecno/mt6789-common &&
rm -rf device/tecno/LG7n-kernel &&
rm -rf device/tecno/LH7n-kernel &&
rm -rf vendor/tecno/LG7n &&
rm -rf vendor/tecno/LH7n &&
rm -rf vendor/tecno/mt6789-common &&
rm -rf vendor/sony/dolby &&
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf vendor/JamesDSP &&
rm -rf hardware/mediatek &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/infinity-priv/keys &&
rm -rf vendor/alpha-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&
rm -rf device/lineage/sepolicy &&
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&
rm -rf out &&

# Local Manifest cloning
git clone https://github.com/Novicio-2309/local_manifests.git -b thepixelproject16 .repo/local_manifests &&

# Initialize Repo
repo init -u https://github.com/The-Pixel-Project/manifest -b 16  --git-lfs &&

# Syncing repo
repo sync --force-sync &&

# Signingkey
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/aosp-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
lunch aosp_LG7n-userdebug &&
make bacon
"
