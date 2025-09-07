#!/bin/bash
set -e

crave run --no-patch -- "
# fix blocked Android.mk (Cherish issue)
find hardware/google/ -type f -name 'Android.mk' -exec mv {} {}.bak \; || true &&

# clear build cache (safe lang, hindi kasama ccache)
rm -rf out/soong out/target &&

# setup environment
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
add_lunch_combo cherish_LG7n-userdebug || true

# start build
brunch LG7n
"
