#!/bin/bash

MODEL=$(echo "$1" | tr '[:lower:]' '[:upper:]')

case "$MODEL" in
    G970N )
        DEVICE="beyond0lteks"
        ;;      
    G973N )
        DEVICE="beyond1lteks"
        ;;       
    G975N )
        DEVICE="beyond2lteks"
        ;;        
    G977N )
        DEVICE="beyondxks"
        ;; 
    N971N )
        DEVICE="d1xks"
        ;;  
    N976N )
        DEVICE="d2xks"
        ;;                        
    * )
        echo "Check Your Model! EX)./build.sh G973N"
        exit 1
        ;;
esac

# KSU
read -p "Do you want to build ksu? (y/n): " ASK_KSU

case "${ASK_KSU}" in
    [yY] )
        KSU="true"
        ;;
    [nN] )
        KSU="false"
        ;;
    * )
        echo "Invalid answer. Please enter 'y' or 'n'."
        exit 1
        ;;
esac

LOCATION=$(pwd)

# Compile Setting
export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s
export ARGS="
ARCH=arm64
CC=$(pwd)/toolchain/clang/host/linux-x86/clang-4639204-cfp-jopp/bin/clang
CROSS_COMPILE=$(pwd)/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CLANG_TRIPLE=$(pwd)/toolchain/clang/host/linux-x86/clang-4639204-cfp-jopp/bin/aarch64-linux-gnu-
"

OUT_DIR="$(pwd)/out"

if [ -d "$OUT_DIR" ]; then
    rm -rf "$OUT_DIR"/*
else
    mkdir -p "$OUT_DIR"
fi

GORHANHEE="$(pwd)/gorhanhee"

if [ -d "$GORHANHEE" ]; then
    rm -rf "$GORHANHEE"/*
else
    mkdir -p "$GORHANHEE"
fi

AIK_DIR="$(pwd)/AIK"

rm -rf ${AIK_DIR}/split_img/boot.img-kernel
rm -rf ${AIK_DIR}/split_img/boot.img-ramdisk.cpio.gz
rm -rf ${AIK_DIR}/ramdisk/system/etc/ramdisk/build.prop
rm -rf ${AIK_DIR}/image-new.img
rm -rf ${AIK_DIR}/ramdisk-new.cpio.gz

# Make Ramdisk file
cp "$(pwd)/ramdisk_prop/${MODEL}.prop" "${AIK_DIR}/ramdisk/system/etc/ramdisk/build.prop"

cd ${AIK_DIR}/ramdisk
find . | cpio -o -H newc | gzip > ../split_img/boot.img-ramdisk.cpio.gz

cd "${LOCATION}"

# Make file
make ${ARGS} -j16 O=${OUT_DIR} mrproper

case "${KSU}" in
    true )
        make ${ARGS} -j16 O=${OUT_DIR} exynos9820-${DEVICE}_defconfig ramdisk.config ksu.config || exit 1
        ;;
    false )
        make ${ARGS} -j16 O=${OUT_DIR} exynos9820-${DEVICE}_defconfig ramdisk.config || exit 1
        ;;
esac

make ${ARGS} -j16 O=${OUT_DIR} || exit 1

IMAGE="$(pwd)/out/arch/arm64/boot/Image"

# Make boot.img file
cp "${IMAGE}" "${AIK_DIR}/split_img/boot.img-kernel"

BOARD="${AIK_DIR}/split_img/boot.img-board"
case "${MODEL}" in
    G970N )
        echo "SRPRI28C007KU" > "$BOARD"
        ;;          
    G973N )
        echo "SRPRI28D007KU" > "$BOARD"
        ;;       
    G975N )
        echo "SRPRI28E007KU" > "$BOARD"
        ;;       
    G977N )
        echo "SRPRK21D006KU" > "$BOARD"
        ;;
    N971N )
        echo "SRPSD23A002KU" > "$BOARD"
        ;; 
    N976N )
        echo "SRPSD23C002KU" > "$BOARD"
        ;;               
esac

cd "${AIK_DIR}"

./repackimg.sh

cd "${LOCATION}"
mv "${AIK_DIR}/image-new.img" "${GORHANHEE}/boot.img"

# Make dt.img file
cd "${LOCATION}"
case "${MODEL}" in
    G970N | G973N | G975N | G977N )
	python3 mkdtboimg.py create dt.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/exynos/exynos9820.dtb --custom0=0x00 --custom1=0xff --id=0x0 --rev=0x0 
        ;;  
    N971N | N976N )
	python3 mkdtboimg.py create dt.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/exynos/exynos9825.dtb --custom0=0x00 --custom1=0xff --id=0x0 --rev=0x0 
        ;;              
esac
mv "dt.img" "${GORHANHEE}/dt.img"

# Make dtbo.img file
cd "${LOCATION}"
case "${MODEL}" in
    G970N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_20.dtbo --custom0=0x14 --custom1=0x18 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_25.dtbo --custom0=0x19 --custom1=0xff --id=0x0 --rev=0x0
        ;;       
    G973N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_20.dtbo --custom0=0x14 --custom1=0x14 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_21.dtbo --custom0=0x15 --custom1=0x19 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_26.dtbo --custom0=0x1a --custom1=0xff --id=0x0 --rev=0x0
        ;;
    G975N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_20.dtbo --custom0=0x14 --custom1=0x17 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_24.dtbo --custom0=0x18 --custom1=0x18 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_25.dtbo --custom0=0x19 --custom1=0x19 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_26.dtbo --custom0=0x1a --custom1=0xff --id=0x0 --rev=0x0
        ;;         
    G977N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_00.dtbo --custom0=0x00 --custom1=0x00 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_01.dtbo --custom0=0x01 --custom1=0x01 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_02.dtbo --custom0=0x02 --custom1=0x02 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_03.dtbo --custom0=0x03 --custom1=0x03 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_04.dtbo --custom0=0x04 --custom1=0x04 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_05.dtbo --custom0=0x05 --custom1=0x05 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_06.dtbo --custom0=0x06 --custom1=0x06 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_07.dtbo --custom0=0x07 --custom1=0x07 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_08.dtbo --custom0=0x08 --custom1=0xff --id=0x0 --rev=0x0
        ;; 
    N971N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_19.dtbo --custom0=0x13 --custom1=0x14 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_23.dtbo --custom0=0x17 --custom1=0xff --id=0x0 --rev=0x0
        ;;  
    N976N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_02.dtbo --custom0=0x02 --custom1=0x0f --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_16.dtbo --custom0=0x10 --custom1=0x10 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_19.dtbo --custom0=0x13 --custom1=0x14 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_23.dtbo --custom0=0x17 --custom1=0x17 --id=0x0 --rev=0x0 \
  	${OUT_DIR}/arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_24.dtbo --custom0=0x18 --custom1=0xff --id=0x0 --rev=0x0
        ;;               
esac
mv "dtbo.img" "${GORHANHEE}/dtbo.img"

# Make tar_file
cd ${GORHANHEE}

case "${KSU}" in
    true )
        tar -cvf ${MODEL}_SuSFS_ramdisk.tar boot.img dt.img dtbo.img
        ;;
    false )
        tar -cvf ${MODEL}_ramdisk.tar boot.img dt.img dtbo.img
        ;;
esac

rm -rf ${AIK_DIR}/split_img/boot.img-kernel
rm -rf ${AIK_DIR}/split_img/boot.img-ramdisk.cpio.gz
rm -rf ${AIK_DIR}/ramdisk-new.cpio.gz
