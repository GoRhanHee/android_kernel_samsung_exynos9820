#!/bin/bash


export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s
export ARCH=arm64
make exynos9820-d1xks_defconfig
make
