#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf vendor/infinity-priv/keys &&
rm -rf hardware/xioami &&
rm -rf device/xioami/amethyst &&
rm -rf device/xioami/amethyst-kernel &&
rm -rf device/qcom/sepolicy_vndr/sm8650 &&
rm -rf vendor/xioami/amethyst &&
rm -rf hardware/dolby &&
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf prebuilts/gcc/linux-x86/arm/arm-linux- androideabi-4.9 &&


#Repo init
repo init --depth=1 -u https://github.com/yaap/manifest.git -b sixteen --git-lfs &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b yaap16 .repo/local_manifests &&

#Sync the full source
/opt/crave/resync.sh &&

#reclone sepolicy
rm -rf device/qcom/sepolicy_vndr/sm8650 &&
git clone https://github.com/amethyst-playground/android_device_qcom_sepolicy_vndr.git -b lineage-23.2-caf-sm8650 device/qcom/sepolicy_vndr/sm8650 --depth=1 &&

#key
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/yaap/signing/keys &&

#Setup environment and start build
source build/envsetup.sh &&
lunch yaap_amethyst-userdebug &&
m yaap
"
