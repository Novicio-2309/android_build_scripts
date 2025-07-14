     #!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# 1. Linisin ang luma mong local_manifests
rm -rf .repo/local_manifests

# 2. I-init ang repo gamit ang tamang manifest (VALID LINK)
repo init --no-repo-verify --git-lfs \
    -u https://github.com/ProjectInfinity-X/manifest \
    -b 16 -g default,-mips,-darwin,-notdefault

# 3. I-clone ang local_manifests mo (SIGURADUHIN na existing ang branch!)
git clone https://github.com/Novicio-2309/local_manifests.git \
    -b infinity-16-bp2a .repo/local_manifests

# 4. I-clone ang signing key template (PUBLIC repo, should work)
git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys

# 5. I-run ang key generator script
cd vendor/infinity-priv/keys
chmod +x keys.sh
./keys.sh
cd ../../../

# 6. Full repo sync gamit ang Crave-resync script (assumes Crave is setup)
if [ -f /opt/crave/resync.sh ]; then
    /opt/crave/resync.sh
else
    echo "[ERROR] /opt/crave/resync.sh not found!"
    exit 1
fi

# 7. Build environment setup
. build/envsetup.sh
lunch infinity_LG7n-userdebug

# 8. Start the build
mka bacon
