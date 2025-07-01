#!/bin/bash
set -e

crave run --no-patch -- "
  # 🔹 Hakbang 1: Linisin ang mga lumang manifest, soong, at keys
  rm -rf .repo/local_manifests && \
  rm -rf vendor/google/gms && \
  rm -rf vendor/gms && \

  # 🔹 Hakbang 2: I-repo init gamit ang InfinityX manifest
  repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs && \

  # 🔹 Hakbang 3: I-clone ang local manifests
  git clone https://github.com/Novicio-2309/local_manifests.git -b evox15-bp2a .repo/local_manifests && \

  # 🔹 Hakbang 4: I-clone ang signing keys at i-generate ito
  git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && \
  cd vendor/evolution-priv/keys && \
  ./keys.sh && \
  cd ../../../.. && \

  # 🔹 Hakbang 5: Gumawa ng config para sa release key
  mkdir -p vendor/infinity-priv/keys && \
  echo 'PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/infinity-priv/keys/releasekey' > vendor/infinity-priv/keys/keys.mk && \

  # 🔹 Hakbang 6: Alisin ang Chrome mula sa GMS
  echo '➤ Inaalis ang Chrome...' && \
  sed -i '/Chrome.apk/s/^/# /' vendor/google/gms/proprietary-files.txt || true && \
  sed -i '/Chrome/s/^/# /' vendor/google/gms/gms-vendor.mk || true && \
  rm -rf vendor/gms/product/app/Chrome || true && \
  find vendor/gms -type f -iname \"Chrome.apk\" -exec rm -f {} \; || true && \
  echo '✅ Tapos na alisin ang Chrome.' && \

  # 🔹 Hakbang 7: I-sync ang buong source
  /opt/crave/resync.sh && \

  # 🔹 Hakbang 8: I-setup ang environment at simulan ang pag-build
  . build/envsetup.sh && \
  lunch lineage_LG7n-bp2a-userdebug && \
  m evolution
"
