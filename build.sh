#!/bin/bash
set -e

# Build sa loob ng Crave devspace
crave run --no-patch -- " \
    # Linisin ang lumang manifest at soong
    rm -rf .repo/local_manifests; \
    rm -rf build/soong; \
    \
    # Repo init gamit ang InfinityX manifest
    repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault; \
    \
    # Clone ng local manifests mo
    git clone https://github.com/Novicio-2309/local_manifests.git -b infinityX-15-bp1a .repo/local_manifests; \
    \
    # Clone ng signing keys at pag-generate ng keys
    git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys; \
    cd vendor/infinity-priv/keys && chmod +x keys.sh && ./keys.sh; \
    cd ../../../; \
    \
    # REMOVE CHROME: i-comment sa proprietary-files.txt at gms-vendor.mk, at burahin sa vendor/gms
    echo '➤ Auto-removing Chrome.apk from proprietary-files.txt, gms-vendor.mk, and vendor/gms...'; \
    sed -i '/Chrome.apk/s/^/# /' vendor/google/gms/proprietary-files.txt; \
    sed -i '/Chrome/s/^/# /' vendor/google/gms/gms-vendor.mk; \
    rm -rf vendor/gms/product/app/Chrome; \
    find vendor/gms -type f -iname \"Chrome.apk\" -exec rm -f {} \; ; \
    echo '✅ Chrome removal complete.'; \
    \
    # Sync ng source code
    /opt/crave/resync.sh; \
    \
    # Setup ng environment
    . build/envsetup.sh; \
    lunch infinity_LG7n-userdebug; \
    \
    # Simulan ang build
    mka bacon
    "
