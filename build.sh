#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf out/soong out/target &&

# Manifest
git clone https://github.com/Novicio-2309/local_manifests.git -b infinity-16-bp2a .repo/local_manifests &&

# Initializing repo
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault &&

# Syncing repo
repo sync --force-sync &&

# Signingkey
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/infinity-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
lunch infinity_LG7n-userdebug &&
m bacon
"
