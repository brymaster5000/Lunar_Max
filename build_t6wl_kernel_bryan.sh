#!/bin/bash

# Path to build your kernel
  k=~/android/kernel/Lunar_Max
# Path for prebuild modules
  pk=~/android/kernel/Max_modules
  pkp=~/android/kernel/Max_modules/prima
# Directory for the any kernel updater
  t=$k/packages
# Date to add to zip
  today=$(date +"%m_%d_%Y")

# Clean old builds
   echo "Clean"
     rm -rf $k/out
#     make clean

# Setup the build
 cd $k/arch/arm/configs/BBKconfigs
    for c in *
      do
        cd $k
# Setup output directory
       mkdir -p "out/$c"
          cp -R "$t/system" out/$c
          cp -R "$t/META-INF" out/$c
          cp -R "$t/kernel" out/$c
       mkdir -p "out/$c/system/lib/modules/"
       mkdir -p "out/$c/system/lib/modules/prima"

  m=$k/out/$c/system/lib/modules
  pm=$pk/out/$c/system/lib/modules
  pmp=$pkp/out/$c/system/lib/modules/prima
  z=$c-$today

TOOLCHAIN=~/android/kernel/arm-eabi-4.7/bin/arm-eabi-
export ARCH=arm
export SUBARCH=arm

# make mrproper
#make CROSS_COMPILE=$TOOLCHAIN -j8 mrproper
 
# remove backup files
find ./ -name '*~' | xargs rm
# rm compile.log

# make kernel
make 't6wl_defconfig'
make -j8 CROSS_COMPILE=$TOOLCHAIN #>> compile.log 2>&1 || exit -1

# Grab modules & zImage
   echo ""
   echo "<<>><<>>  Collecting modules and zimage <<>><<>>"
   echo ""
   cp $k/arch/arm/boot/zImage out/$c/kernel/kernel
   for mo in $(find . -name "*.ko"); do
		cp "${mo}" $m
   for mo in $pk(find . -name "*.ko"); do
		cp "${mo}" $pm
   for mo in $pkp(find . -name "*.ko"); do
		cp "${mo}" $pmp
   done

# Build Zip
 clear
   echo "Creating $z.zip"
     cd $k/out/$c/
       7z a "$z.zip"
         mv $z.zip $k/out/$z.zip
# cp $k/out/$z.zip $db/$z.zip
#           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
      done

