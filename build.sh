#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf out/soong out/target &&

# Signingkey
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/infinity-priv/keys &&

#Setup environment and start build
. build/envsetup.sh &&
lunch infinity_LG7n-userdebug &&
m bacon
"
