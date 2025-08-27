#!/bin/bash
set -e

crave run --no-patch -- "
  # 🔹 Hakbang 1: Linisin ang mga lumang manifest, soong, at keys
  rm -rf .repo/local_manifests &&
  rm -rf device/tecno/LG7n &&
  rm -rf device/tecno/mt6789-common &&
  rm -rf device/tecno/LG7n-kernel &&
  rm -rf vendor/tecno/LG7n &&
  rm -rf vendor/tecno/mt6789-common &&
  rm -rf vendor/sony/dolby &&
  rm -rf packages/apps/ViPER4AndroidFX &&
  rm -rf vendor/JamesDSP &&
  rm -rf hardware/mediatek &&
  rm -rf hardware/transsion &&
  rm -rf device/mediatek/sepolicy_vndr &&
  rm -rf vendor/alpha-priv/keys &&
  rm -rf vendor/lineage-priv/keys &&
  rm -rf build/soong &&
  rm -rf vendor/google/gms &&
  rm -rf vendor/gms &&

  # Local manifest
  git clone https://github.com/Novicio-2309/local_manifests.git -b evox16 .repo/local_manifests &&
  
  # Initialize Repo
  repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs &&
  
  # Syncing
  repo sync --force-sync &&
  
  # Signgkey
  
  # 🔹 Hakbang 6: I-setup ang environment at simulan ang pag-build
  . build/envsetup.sh && \
  lunch lineage_LG7n-bp2a-userdebug && \
  m evolution
"
