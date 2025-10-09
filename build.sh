#!/bin/bash
set -e

crave run --no-patch -- "
# Clean up old trees (This section should contain all your rm -rf commands)
rm -rf .repo/local_manifests &&
rm -rf device/tecno/LH7n &&
rm -rf device/tecno/LG7n &&
rm -rf device/tecno/mt6789-common &&
rm -rf device/tecno/LG7n-kernel &&
rm -rf device/tecno/LH7n-kernel &&
rm -rf vendor/tecno/LG7n &&
rm -rf vendor/tecno/LH7n &&
rm -rf vendor/tecno/mt6789-common &&
rm -rf vendor/sony/dolby &&
rm -rf packages/apps/ViPER4AndroidFX &&
rm -rf vendor/JamesDSP &&
rm -rf hardware/mediatek &&
rm -rf hardware/transsion &&
rm -rf device/mediatek/sepolicy_vndr &&
rm -rf vendor/infinity-priv/keys &&
rm -rf vendor/alpha-priv/keys &&
rm -rf vendor/witaqua-priv/keys &&
rm -rf build/soong &&
rm -rf vendor/google/gms &&
rm -rf vendor/gms &&
rm -rf device/lineage/sepolicy &&
rm -rf external/chromium-webview &&
rm -rf prebuilts/clang/host/linux-x86 &&
rm -rf platform/prebuilts/clang/host/linux-x86 &&
rm -rf out &&

# Initialize repo
repo init -u https://github.com/alphadroid-project/manifest -b alpha-16.1 --git-lfs &&

# Clone local manifest after init
git clone https://github.com/Novicio-2309/local_manifests.git -b alphadroid16 .repo/local_manifests &&

# --- SYNC ATTEMPT 1: Hahayaan itong mag-fail at mag-download ng metadata ---
repo sync --force-sync || true &&

# --- SYNC FIX: Tatanggalin ang Corrupted Metadata (Telegram Fix) ---
echo "Applying sync fix..." &&

rm -rf .repo/projects/manifest_git &&
rm -rf .repo/projects/packages/inputmethods/LatinIME.git &&
rm -rf packages/inputmethods/LatinIME &&

# --- SYNC ATTEMPT 2: Final Sync. Dito maaayos at makukumpleto ang files ---
repo sync --force-sync &&

# Signing key
git clone --depth=1 https://github.com/Novicio-2309/signingkey vendor/lineage-priv/keys &&

# Setup environment and start build
. build/envsetup.sh &&
lunch alpha_LG7n-userdebug &&
make bacon
"
