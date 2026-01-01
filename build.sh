#!/bin/bash

# Define toolchain variables
CLANG_DIR=$PWD/toolchain/neutron_18
PATH=$CLANG_DIR/bin:$PATH

# Check if toolchain exists
if [ ! -f "$CLANG_DIR/bin/clang-18" ]; then
    echo "-----------------------------------------------"
    echo "Toolchain not found! Downloading..."
    echo "-----------------------------------------------"
    rm -rf $CLANG_DIR
    mkdir -p $CLANG_DIR
    pushd toolchain/neutron_18 > /dev/null
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S=05012024
    echo "-----------------------------------------------"
    echo "Patching toolchain..."
    echo "-----------------------------------------------"
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") --patch=glibc
    echo "-----------------------------------------------"
    echo "Cleaning up..."
    popd > /dev/null
fi

export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

MAKE_ARGS="
LLVM=1 \
LLVM_IAS=1 \
ARCH=arm64 \
O=out
"

make ${MAKE_ARGS} -j16 exynos9820-beyond1lteks_defconfig || exit 1
make ${MAKE_ARGS} -j16 || exit 1
