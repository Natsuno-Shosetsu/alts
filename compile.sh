#!/bin/sh
#
# Compile script kernel
# Copyright (C) 2024-2025 Rve.

git clone --depth=1 https://github.com/Mi-Eldarion/msm-4.19 kernel

cd kernel

git clone https://github.com/Mi-Eldarion/kernel_devicetree-ysl arm64/boot/dts/vendor/qcom/ysl

git clone https://github.com/Mi-Eldarion/kernel_techpack_ysl techpack/mi8953

wget https://github.com/Rv-Project/RvClang/releases/download/20.1.0/RvClang-20.1.0-bolt-pgo-full_lto.tar.gz

tar -xvzf RvClang-20.1.0-bolt-pgo-full_lto.tar.gz

CLANGDIR="/home/rve/RvClang"

rm out/compile.log
mkdir -p out

export KBUILD_BUILD_USER=RennAlt
export KBUILD_BUILD_HOST=Mi-Eldarion
export USE_CCACHE=1
export PATH="$CLANGDIR/bin:$PATH"

make O=out ARCH=arm64 vendor/msm8953-perf_defconfig

rve () {
make -j$(nproc --all) O=out LLVM=1 LLVM_IAS=1 \
ARCH=arm64 \
CC=clang \
LD=ld.lld \
AR=llvm-ar \
AS=llvm-as \
NM=llvm-nm \
STRIP=llvm-strip \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
READELF=llvm-readelf \
HOSTCC=clang \
HOSTCXX=clang++ \
HOSTAR=llvm-ar \
HOSTLD=ld.lld \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}

rve 2>&1 | tee -a out/compile.log
