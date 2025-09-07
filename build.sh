#!/bin/bash
set -e

crave run --no-patch -- "
# Remove old local manifests
rm -rf .repo/local_manifests &&
rm -rf device/tecno/LG7n &&
rm -rf device/tecno/LH7n &&
rm -rf device/tecno/mt6789-common &&
rm -rf device/tecno/LG7n-kernel &&
rm -rf device/tecno/LH7n-kernel &&
rm -rf vendor/tecno/LG7n &&
rm -rf vendor/tecno/LH7n &&
rm -rf vendor/tecno/mt6789-common &&
rm -rf vendor/sony/dolby &&
rm -rf vendor/JamesDSP &&
rm -rf hardware/mediatek &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/cherish-priv/keys &&
rm -rf vendor/lineage-priv/keys &&
rm -rf vendor/alpha-priv/keys &&
rm -rf vendor/infinity-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/gms &&
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&
rm -rf out &&

# Clone updated local manifest
git clone https://github.com/Novicio-2309/local_manifests.git -b cherishOS-16 .repo/local_manifests &&

# Syncing the source
repo init -u https://github.com/CherishOS/android_manifest.git -b sixteen &&

# Sync sources with new manifest
repo sync --force-sync &&

#signing keys and run setup
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/cherish-priv/keys &&

# Setup environment and start build
. build/envsetup.sh &&
brunch cherish_LG7n
"
