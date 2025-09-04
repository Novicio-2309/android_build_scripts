#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf device/tecno/LG7n &&
rm -rf device/tecno/LH7n &&
rm -rf device/tecno/mt6789-common &&
rm -rf device/tecno/LH7n-kernel &&
rm -rf vendor/tecno/LH7n &&
rm -rf vendor/tecno/mt6789-common &&
rm -rf vendor/sony/dolby &&
rm -rf vendor/JamesDSP &&
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf hardware/mediatek &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/lineage-priv/keys &&
rm -rf vendor/derp/signing/keys &&
rm -rf vendor/voltage-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&
rm -rf out &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b LH7n-derp16 .repo/local_manifests &&

#Repo init
repo init -u https://github.com/RisingOS-Revived/android -b sixteen-los --git-lfs &&

#Sync the full source
repo sync --force-sync &&

#signing keys and run setup
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
riseup LG7n userdebug &&
rise b
"
