     # Linisin ang lumang manifest at soong
    "rm -rf .repo/local_manifests &&
         # Repo init gamit ang InfinityX manifest
    repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault &&
         # Clone ng local manifests mo
    git clone https://github.com/Novicio-2309/local_manifests.git -b infinity-16-bp2a .repo/local_manifests &&
         # Clone ng signing keys at pag-generate ng keys
    git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys &&
     cd vendor/infinity-priv/keys && chmod +x keys.sh && ./keys.sh &&
     cd ../../../
         # Sync ng source code
    /opt/crave/resync.sh &&
         # Setup ng environment
    . build/envsetup.sh &&
     lunch infinity_LG7n-userdebug
         # Simulan ang build
    mka bacon"
