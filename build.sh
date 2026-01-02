#!/bin/bash

# OEM Setting
export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

# Setting toolchain
TOOLCHAIN_URL="https://github.com/GoRhanHee/exynos9820_toolchain/releases/download/toolchain/toolchain.tar.xz"
TOOLCHAIN_FILE=$(basename "$TOOLCHAIN_URL")
if [ ! -f "$TOOLCHAIN_FILE" ]; then
    wget -q --show-progress -O "$TOOLCHAIN_FILE" "$TOOLCHAIN_URL"
fi

# Cooking Kernel Source
MAKE_ARGS="
ARCH=arm64 \
-j16 \
O=out
"

make ${MAKE_ARGS} exynos9820-beyond1lteks_defconfig gorhanhee.config || exit 1
make ${MAKE_ARGS} || exit 1
