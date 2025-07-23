#!/bin/bash

MODEL=$(echo "$1" | tr '[:lower:]' '[:upper:]')

case "$MODEL" in
    G970F )
        DEVICE="beyond0lte"
        ;;
    G970N )
        DEVICE="beyond0lteks"
        ;;
    G973F )
        DEVICE="beyond1lte"
        ;;        
    G973N )
        DEVICE="beyond1lteks"
        ;;
    G975F )
        DEVICE="beyond2lte"
        ;;        
    G975N )
        DEVICE="beyond2lteks"
        ;;
    G977B )
        DEVICE="beyondx"
        ;;         
    G977N )
        DEVICE="beyondxks"
        ;;
    N970F )
        DEVICE="d1"
        ;;        
    N971N )
        DEVICE="d1xks"
        ;;
    N975F )
        DEVICE="d2s"
        ;;          
    N976N )
        DEVICE="d2xks"
        ;;        
    * )
        echo "Check Your Model! EX)./build_kernel.sh G977N"
        exit 1
        ;;
esac

LOCATION=$(pwd)

# tzdev
rm -rf "${LOCATION}/drivers/misc/tzdev"

case "$MODEL" in
    G970F | G970N | G973F | G973N | G975F | G975N | G977B | G977N | N971N | N976N )
 	cp -ar "${LOCATION}/tzdev_setting/A/tzdev" "${LOCATION}/drivers/misc/tzdev"
        ;;
    N970F | N975F )
 	cp -ar "${LOCATION}/tzdev_setting/B/tzdev" "${LOCATION}/drivers/misc/tzdev"
        ;;            
esac

# Compile Setting
export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

make -j16 mrproper

make ARCH=arm64 -j16 ${DEVICE}_defconfig || exit 1
make ARCH=arm64 -j16 || exit 1


# Make file
IMAGE="arch/arm64/boot/Image"
AIK_DIR="AIK"
OUT_DIR="out"

if [ -d "$OUT_DIR" ]; then
    rm -rf "$OUT_DIR"/*
else
    mkdir -p "$OUT_DIR"
fi

# Make boot.img file
cp "$IMAGE" "$AIK_DIR/split_img/boot.img-kernel"

BOARD="$AIK_DIR/split_img/boot.img-board"
case "$MODEL" in
    G970F )
        echo "SRPRI28A016KU" > "$BOARD"
        ;;
    G970N )
        echo "SRPRI28C007KU" > "$BOARD"
        ;;
    G973F )
        echo "SRPRI28B016KU" > "$BOARD"
        ;;            
    G973N )
        echo "SRPRI28D007KU" > "$BOARD"
        ;;
    G975F )
        echo "SRPRI17C016KU" > "$BOARD"
        ;;        
    G975N )
        echo "SRPRI28E007KU" > "$BOARD"
        ;;
    G977B )
        echo "SRPSC04B014KU" > "$BOARD"
        ;;        
    G977N )
        echo "SRPRK21D006KU" > "$BOARD"
        ;;
    N970F )
    	echo "SRPSD26B009KU" > "$BOARD"
    	;;
    N971N )
        echo "SRPSD23A002KU" > "$BOARD"
        ;;
    N975F )
    	echo "SRPSC14B009KU" > "$BOARD"
    	;;
    N976N )
        echo "SRPSD23C002KU" > "$BOARD"
        ;;
esac

cd "$AIK_DIR"
mkdir ramdisk
./repackimg.sh

cd "$LOCATION"
mv "$AIK_DIR/image-new.img" "$OUT_DIR/boot.img"

# Make dt.img file
cd "$LOCATION"
case "$MODEL" in
    G970F | G970N | G973F | G973N | G975F | G975N | G977B | G977N )
	python3 mkdtboimg.py create dt.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/exynos/exynos9820.dtb --custom0=0x00 --custom1=0xff --id=0x0 --rev=0x0 
        ;;
    N970F | N971N | N975F | N976N )
	python3 mkdtboimg.py create dt.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/exynos/exynos9825.dtb --custom0=0x00 --custom1=0xff --id=0x0 --rev=0x0 
        ;;      
esac
mv "dt.img" "$OUT_DIR/dt.img"

# Make dtbo.img file
cd "$LOCATION"
case "$MODEL" in
    G970F )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_20.dtbo --custom0=0x14 --custom1=0x15 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_22.dtbo --custom0=0x16 --custom1=0x17 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_24.dtbo --custom0=0x18 --custom1=0x18 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_eur_open_25.dtbo --custom0=0x19 --custom1=0xff --id=0x0 --rev=0x0 	
        ;;
    G970N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_20.dtbo --custom0=0x14 --custom1=0x18 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond0lte_kor_25.dtbo --custom0=0x19 --custom1=0xff --id=0x0 --rev=0x0
        ;;
    G973F )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_20.dtbo --custom0=0x14 --custom1=0x14 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_23.dtbo --custom0=0x17 --custom1=0x17 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_24.dtbo --custom0=0x18 --custom1=0x19 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_eur_open_26.dtbo --custom0=0x1a --custom1=0xff --id=0x0 --rev=0x0 
        ;;        
    G973N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_20.dtbo --custom0=0x14 --custom1=0x14 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_21.dtbo --custom0=0x15 --custom1=0x19 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond1lte_kor_26.dtbo --custom0=0x1a --custom1=0xff --id=0x0 --rev=0x0
        ;;
    G975F )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_04.dtbo --custom0=0x04 --custom1=0x0f --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_16.dtbo --custom0=0x10 --custom1=0x10 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_20.dtbo --custom0=0x14 --custom1=0x16 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_23.dtbo --custom0=0x17 --custom1=0x17 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_24.dtbo --custom0=0x18 --custom1=0x18 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_25.dtbo --custom0=0x19 --custom1=0x19 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_eur_open_26.dtbo --custom0=0x1a --custom1=0xff --id=0x0 --rev=0x0 
  	;;
    G975N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_20.dtbo --custom0=0x14 --custom1=0x17 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_24.dtbo --custom0=0x18 --custom1=0x18 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_25.dtbo --custom0=0x19 --custom1=0x19 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyond2lte_kor_26.dtbo --custom0=0x1a --custom1=0xff --id=0x0 --rev=0x0
        ;;
    G977B )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_00.dtbo --custom0=0x00 --custom1=0x00 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_01.dtbo --custom0=0x01 --custom1=0x01 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_02.dtbo --custom0=0x02 --custom1=0x02 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_03.dtbo --custom0=0x03 --custom1=0x03 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_04.dtbo --custom0=0x04 --custom1=0x04 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_05.dtbo --custom0=0x05 --custom1=0x05 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_06.dtbo --custom0=0x06 --custom1=0x06 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_07.dtbo --custom0=0x07 --custom1=0x07 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_eur_open_08.dtbo --custom0=0x08 --custom1=0xff --id=0x0 --rev=0x0
        ;;         
    G977N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_00.dtbo --custom0=0x00 --custom1=0x00 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_01.dtbo --custom0=0x01 --custom1=0x01 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_02.dtbo --custom0=0x02 --custom1=0x02 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_03.dtbo --custom0=0x03 --custom1=0x03 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_04.dtbo --custom0=0x04 --custom1=0x04 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_05.dtbo --custom0=0x05 --custom1=0x05 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_06.dtbo --custom0=0x06 --custom1=0x06 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_07.dtbo --custom0=0x07 --custom1=0x07 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-beyondx_kor_08.dtbo --custom0=0x08 --custom1=0xff --id=0x0 --rev=0x0
        ;; 
    N970F )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1_eur_open_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1_eur_open_19.dtbo --custom0=0x13 --custom1=0x14 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1_eur_open_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1_eur_open_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1_eur_open_23.dtbo --custom0=0x17 --custom1=0xff --id=0x0 --rev=0x0
        ;;        
    N971N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_19.dtbo --custom0=0x13 --custom1=0x14 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d1x_kor_23.dtbo --custom0=0x17 --custom1=0xff --id=0x0 --rev=0x0
        ;;
    N975F )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_02.dtbo --custom0=0x02 --custom1=0x0f --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_16.dtbo --custom0=0x10 --custom1=0x10 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_19.dtbo --custom0=0x13 --custom1=0x13 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_20.dtbo --custom0=0x14 --custom1=0x14 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_23.dtbo --custom0=0x17 --custom1=0x17 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2_eur_open_24.dtbo --custom0=0x18 --custom1=0xff --id=0x0 --rev=0x0
        ;;         
    N976N )
        python3 mkdtboimg.py create dtbo.img \
  	--page_size=2048 \
  	--version=0 \
  	--id=0x0 --rev=0x0 --custom0=0x0 --custom1=0x0 --custom2=0x0 --custom3=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_02.dtbo --custom0=0x02 --custom1=0x0f --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_16.dtbo --custom0=0x10 --custom1=0x10 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_17.dtbo --custom0=0x11 --custom1=0x11 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_18.dtbo --custom0=0x12 --custom1=0x12 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_19.dtbo --custom0=0x13 --custom1=0x14 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_21.dtbo --custom0=0x15 --custom1=0x15 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_22.dtbo --custom0=0x16 --custom1=0x16 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_23.dtbo --custom0=0x17 --custom1=0x17 --id=0x0 --rev=0x0 \
  	arch/arm64/boot/dts/samsung/exynos9820-d2x_kor_24.dtbo --custom0=0x18 --custom1=0xff --id=0x0 --rev=0x0
        ;;        
esac
mv "dtbo.img" "$OUT_DIR/dtbo.img"

# Make tar_file
cd $OUT_DIR
tar -cvf ${MODEL}_KSUN_SUSFS.tar boot.img dt.img dtbo.img
