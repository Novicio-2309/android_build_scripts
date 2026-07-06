#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf .repo/local_manifests &&

#Repo init
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault &&

#Clone local manifests
git clone https://github.com/Novicio-2309/local_manifests.git -b Infinity16-amethyst .repo/local_manifests &&

#Sync the full source
/opt/crave/resync.sh &&

#Setup environment and start build
. build/envsetup.sh &&
lunch infinity_amethyst-userdebug &&
m bacon
"
