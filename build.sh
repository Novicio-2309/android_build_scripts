#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&
rm -rf device_xiaomi_amethyst-recovery &&

#Clone local manifests
git clone https://github.com/Novicio-2309/device_xiaomi_amethyst-recovery &&

#Repo init
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-14 &&

#Sync the full source
/opt/crave/resync.sh &&

#Setup environment and start build
source build/envsetup.sh && lunch twrp_amethyst-ap2a-eng && mka adbd recoveryimage
"
