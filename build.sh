#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b Lunaris16Qpr2 .repo/local_manifests &&

#Repo init
repo init -u https://github.com/Lunaris-AOSP/android -b 16.2 --git-lfs &&

#Sync the full source
/opt/crave/resync.sh &&

#signing keys and run setup
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys &&

#Setup environment and start build
. b*/env* &&
lunch lineage_LG7n-bp4a-userdebug &&
m bacon
"
