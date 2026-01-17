#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&

#Clone local manifests
git clone https://github.com/Novicio-2309/device_xiaomi_amethyst-recovery &&

#Repo init
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-14.1 &&

#Sync the full source
/opt/crave/resync.sh &&

#Setup environment and start build
lunch twrp_amethyst-ap2a-eng && mka adbd recoveryimage
"
