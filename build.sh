#!/bin/bash

# submodule
git submodule init && git submodule update --remote

# Compiling Setting
export MODEL=$1
export ANDROID_BUILD_TOP=$(pwd)
export AIK_DIR=${ANDROID_BUILD_TOP}/prebuilts/AIK
export OUT_DIR=${ANDROID_BUILD_TOP}/out

# Define specific variables
case ${MODEL} in
beyond0lte)
    BOARD=SRPRI28A016KU
    SOC=exynos9820
    TZDEV=new
;;
beyond0lteks)
    BOARD=SRPRI28C007KU
    SOC=exynos9820
    TZDEV=new
;;
beyond1lte)
    BOARD=SRPRI28B016KU
    SOC=exynos9820
    TZDEV=new
;;
beyond1lteks)
    BOARD=SRPRI28D007KU
    SOC=exynos9820
    TZDEV=new
;;
beyond2lte)
    BOARD=SRPRI17C016KU
    SOC=exynos9820
    TZDEV=new
;;
beyond2lteks)
    BOARD=SRPRI28E007KU
    SOC=exynos9820
    TZDEV=new
;;
beyondx)
    BOARD=SRPSC04B014KU
    SOC=exynos9820
    TZDEV=new
;;
beyondxks)
    BOARD=SRPRK21D006KU
    SOC=exynos9820
    TZDEV=new
;;
d1)
    BOARD=SRPSD26B009KU
    SOC=exynos9825
    TZDEV=old
;;
d1xks)
    BOARD=SRPSD23A002KU
    SOC=exynos9825
    TZDEV=new
;;
d2s)
    BOARD=SRPSC14B009KU
    SOC=exynos9825
    TZDEV=old
;;
d2x)
    BOARD=SRPSC14C009KU
    SOC=exynos9825
    TZDEV=old
;;
d2xks)
    BOARD=SRPSD23C002KU
    SOC=exynos9825
    TZDEV=new
;;
*)
    exit
esac
echo -n "${BOARD}" > "${AIK_DIR}/split_img/boot.img-board"

# Add Specific Device DEFCONFIG
export MODEL_UPPER=$(echo "${MODEL}" | tr '[:lower:]' '[:upper:]')
echo -e "\nCONFIG_MODEL_${MODEL_UPPER}=y" >> "${ANDROID_BUILD_TOP}/arch/arm64/configs/${SOC}.config"

# Setting tzdev drvier
# All Galaxy S10 Series and Korean Note 10 Series use new tzdev drvier, but Global Note 10 Series uses old tzdev drvier
# So, we need this file setting codes (Scamsung issue)
rm -rf ${ANDROID_BUILD_TOP}/drivers/misc/tzdev
cp -ar ${ANDROID_BUILD_TOP}/prebuilts/tzdev/tzdev_${TZDEV} ${ANDROID_BUILD_TOP}/drivers/misc/tzdev

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
tar -xf "$TOOLCHAIN_FILE" && rm "$TOOLCHAIN_FILE"

# Cooking Kernel Source
MAKE_ARGS="
ARCH=arm64 \
-j16 \
O=out
"
make ${MAKE_ARGS} exynos9820-${MODEL}_defconfig ${SOC}.config || exit 1
make ${MAKE_ARGS} || exit 1

# Cooking Ramdisk
cp ${ANDROID_BUILD_TOP}/prebuilts/ramdisk_prop/${MODEL}.prop ${AIK_DIR}/ramdisk/system/etc/ramdisk/build.prop
cd ${AIK_DIR}/ramdisk
find . | cpio -o -H newc | gzip > ../split_img/boot.img-ramdisk.cpio.gz

cd ${ANDROID_BUILD_TOP}

# Cooking boot.img
cp ${OUT_DIR}/arch/arm64/boot/Image ${AIK_DIR}/split_img/boot.img-kernel
cd ${AIK_DIR} && ./repackimg.sh
cd ${ANDROID_BUILD_TOP}
mv ${AIK_DIR}/image-new.img ${ANDROID_BUILD_TOP}/prebuilts/boot.img

# Cooking dt.img
./prebuilts/mkdtimg cfg_create prebuilts/dt.img prebuilts/dtconfigs/${SOC}.cfg -d ${OUT_DIR}/arch/arm64/boot/dts/exynos

# Cooking dtbo.img
./prebuilts/mkdtimg cfg_create prebuilts/dtbo.img prebuilts/dtconfigs/${MODEL}.cfg -d ${OUT_DIR}/arch/arm64/boot/dts/samsung

# Cooking flashable zip file
cd ${ANDROID_BUILD_TOP}/prebuilts
zip -r ${SOC}_${MODEL}_Kernel.zip META-INF boot.img dt.img dtbo.img