#!/bin/bash
set -e

crave run --no-patch -- "
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
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf hardware/mediatek &&
rm -rf packages/apps/ParanoidSense &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/lineage-priv/keys &&
rm -rf vendor/derp/signing/keys &&
rm -rf vendor/voltage-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf external/chromium-webview_prebuilt
rm -rf vendor/google/overlays &&
rm -rf vendor/gms &&
rm -rf external/chromium-webview &&
rm -rf device/lineage/sepolicy &&
rm -rf vendor/official_devices &&
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b aviumui16 .repo/local_manifests &&

#Repo init
repo init -u https://github.com/AviumUI/android_manifests -b avium-16 --git-lfs &&

#Sync the full source
/opt/crave/resync.sh &&

#signing keys and run setup
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
lunch lineage_LG7n-bp2a-userdebug &&
m bacon
"
