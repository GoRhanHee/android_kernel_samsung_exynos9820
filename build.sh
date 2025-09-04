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
    * )
        echo "Check Your Model! EX)./build.sh G973N"
        exit 1
        ;;
esac

LOCATION=$(pwd)

# Compile Setting
export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

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

rm -rf $(pwd)/AIK/split_img/boot.img-kernel
rm -rf $(pwd)/AIK/image-new.img

make ARCH=arm64 -j16 O=${OUT_DIR} mrproper
make ARCH=arm64 -j16 O=${OUT_DIR} exynos9820-${DEVICE}_defconfig ramdisk.config || exit 1
make ARCH=arm64 -j16 O=${OUT_DIR} || exit 1

# Make file
IMAGE="$(pwd)/out/arch/arm64/boot/Image"
AIK_DIR="$(pwd)/AIK"

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
esac
mv "dtbo.img" "${GORHANHEE}/dtbo.img"

# Make tar_file
cd ${GORHANHEE}
tar -cvf ${MODEL}_ramdisk.tar boot.img dt.img dtbo.img
