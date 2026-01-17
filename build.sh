#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&

#Clone local manifests
git clone https://github.com/Novicio-2309/device_xiaomi_amethyst-recovery &&

#Repo init
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-14.1 &&

#Sync the full source
repo sync --force-sync &&

#Setup environment and start build
export ALLOW_MISSING_DEPENDENCIES=true &&
. build/envsetup.sh &&
lunch twrp_amethyst-eng &&
mka recoveryimage
"
