#!/bin/bash
set -e

crave run --no-patch -- "
# Fix Cherish issue: block Android.mk inside hardware/google
find hardware/google/ -type f -name 'Android.mk' -exec mv {} {}.bak \; || true

# Clear build output (safe, hindi kasama ccache)
rm -rf out/soong out/target

# Setup environment
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh

# Start build (now registered via COMMON_LUNCH_CHOICES)
brunch cherish_LG7n-userdebug
"
