#!/bin/bash
set -e

crave run --no-patch -- "
  # 🔹 Hakbang 1: Linisin ang mga lumang manifest, soong, at keys
  rm -rf .repo/local_manifests && \
  rm -rf device/tecno/LG7n && \
  rm -rf device/tecno/mt6789-common && \
  rm -rf device/tecno/LG7n-kernel && \
  rm -rf vendor/tecno/LG7n && \
  rm -rf vendor/tecno/mt6789-common && \
  rm -rf vendor/sony/dolby && \
  rm -rf packages/apps/ViPER4AndroidFX && \
  rm -rf hardware/mediatek && \
  rm -rf hardware/transsion && \
  rm -rf device/mediatek/sepolicy_vndr && \
  rm -rf vendor/alpha-priv/keys && \
  rm -rf build/soong && \
  rm -rf vendor/google/gms && \
  rm -rf vendor/gms && \

  # 🔹 Hakbang 2: I-repo init gamit ang InfinityX manifest
  repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs && \

  # 🔹 Hakbang 3: I-clone ang local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b evox15-bp2a .repo/local_manifests && \

# signingkey Evox default
git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && \
cd vendor/evolution-priv/keys && \
./keys.sh && \

  # 🔹 Hakbang 7: I-sync ang buong source
  /opt/crave/resync.sh && \

  # 🔹 Hakbang 8: I-setup ang environment at simulan ang pag-build
  . build/envsetup.sh && \
  lunch lineage_LG7n-bp2a-userdebug && \
  m evolution
"
