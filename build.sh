#!/bin/bash
set -e

crave run --no-patch -- "
rm -rf out/soong out/target &&
. build/envsetup.sh &&
brunch LG7n
"
