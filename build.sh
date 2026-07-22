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
rm -rf hardware/dolby &&
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf prebuilts/gcc/linux-x86/arm/arm-linux- androideabi-4.9 &&
rm -rf external/ant-wireless &&
rm -rf packages/apps/LunarisDolby &&
rm -rf external/ant-wireless/ant_native/Android.mk &&
rm -rf vendor/yaap &&
rm -rf yaap &&
rm -rf hardware/lineage/build/soong/generator &&
rm -rf vendor/themes &&

#Repo init
repo init --depth=1 -u https://github.com/AviumUI/android_manifests -b avium-16.2 --git-lfs &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b Avium16 .repo/local_manifests &&

#Sync the full source
/opt/crave/resync.sh &&

#reclone sepolicy
rm -rf device/qcom/sepolicy_vndr/sm8650 &&
git clone https://github.com/BluedMC-Amethyst/device_qcom_sepolicy_vndr.git -b lineage-23.2-caf-sm8650 device/qcom/sepolicy_vndr/sm8650 --depth=1 &&

#key
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys &&

# Automatic insertion for sepolicy ignore.cil files
echo 'Adding devicesettings_app and settingslib_prop to ignore.cil files...' &&

# For 34.0 ignore.cil
if [ -f system/sepolicy/private/compat/34.0/34.0.ignore.cil ]; then
    grep -q 'devicesettings_app' system/sepolicy/private/compat/34.0/34.0.ignore.cil || echo -e '\ndevicesettings_app' >> system/sepolicy/private/compat/34.0/34.0.ignore.cil
    grep -q 'settingslib_prop' system/sepolicy/private/compat/34.0/34.0.ignore.cil || echo -e 'settingslib_prop' >> system/sepolicy/private/compat/34.0/34.0.ignore.cil
fi &&

# For 202404 ignore.cil
if [ -f system/sepolicy/private/compat/202404/202404.ignore.cil ]; then
    grep -q 'devicesettings_app' system/sepolicy/private/compat/202404/202404.ignore.cil || echo -e '\ndevicesettings_app' >> system/sepolicy/private/compat/202404/202404.ignore.cil
    grep -q 'settingslib_prop' system/sepolicy/private/compat/202404/202404.ignore.cil || echo -e 'settingslib_prop' >> system/sepolicy/private/compat/202404/202404.ignore.cil
fi &&

#Setup environment and start build
. build/envsetup.sh &&
lunch lineage_amethyst-bp4a-userdebug &&
m bacon
"
