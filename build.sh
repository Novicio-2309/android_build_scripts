#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf vendor/infinity-priv/keys &&
rm -rf vendor/lineage-priv/keys &&
rm -rf hardware/xioami &&
rm -rf device/xioami/amethyst &&
rm -rf device/xioami/amethyst-kernel &&
rm -rf device/qcom/sepolicy_vndr/sm8650 &&
rm -rf vendor/xioami/amethyst &&
rm -rf device/qcom/sepolicy_vndr/sm8650 &&
rm -rf hardware/dolby &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&
rm -rf device/lineage/sepolicy &&
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&
rm -rf vendor/official_devices &&
rm -rf prebuilts/clang/host/linux-x86/clang-r530567/bin &&


#Repo init
repo init --depth=1 -u https://github.com/Lunaris-AOSP/android -b 16.2 --git-lfs &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b Lunaris-amethyst .repo/local_manifests &&

#Sync the full source
/opt/crave/resync.sh &&

#reclone sepolicy
rm -rf device/qcom/sepolicy_vndr/sm8650 &&
git clone https://github.com/amethyst-playground/android_device_qcom_sepolicy_vndr.git -b lineage-23.2-caf-sm8650 device/qcom/sepolicy_vndr/sm8650 --depth=1 &&

# Dolby Hardware
rm -rf hardware/dolby &&
git clone --depth=1 https://github.com/LineageOS-extra/android_hardware_dolby.git -b lineage-23.2 hardware/dolby &&

#key
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys &&

#Setup environment and start build
. b*/env* &&
lunch lineage_amethyst-bp4a-userdebug &&
m bacon
"
