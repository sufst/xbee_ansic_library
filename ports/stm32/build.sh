#!/bin/sh

# Script for building library ZIP file for use on STM32FX platform with ThreadX (tx_time_get() might be replaced by HAL Timer if needed)

# path to XBee ANSI C Host Library
PWD=`pwd`
DRIVER=$PWD/../..
BUILD=$DRIVER/lib/xbee-stm32
rm -rf $BUILD
mkdir -p $BUILD
mkdir -p $BUILD/include
mkdir -p $BUILD/src

cp -a $DRIVER/src/{util,wpan,xbee,zigbee} $DRIVER/ports/stm32 $BUILD/src/

# Copy headers while renaming to avoid naming conflicts with stm32
# headers (like xbee/driver.h).
shopt -s nullglob
for d in wpan xbee zigbee
do
  mkdir -p $BUILD/include/$d
  cd $DRIVER/include/$d
  for f in *.h
  do
    echo "${d}_${f}"
    cp -a "$f" "$BUILD/include/$d/${d}_${f}"
  done
  cd -
done

# Remove this build script from the copied files.
rm $BUILD/src/stm32/build.sh

# Create modified xbee/xbee_platform.h since we can't define XBEE_PLATFORM_HEADER
# in a project file or Makefile.
echo "#define XBEE_PLATFORM_HEADER \"../../src/stm32/platform_config.h\"" > $BUILD/include/xbee/xbee_platform.h 
cat $DRIVER/include/xbee/platform.h >> $BUILD/include/xbee/xbee_platform.h

# remove commissioning code (wants to link zcl_comm_default_sas)
rm $BUILD/*/*/*commissioning*

# remove OTA code (wants to link xbee_update_firmware_ota)
rm $BUILD/*/*/*_ota_*

# Fix the #include statements throughout the program to reference munged names.
sed -ri -e 's|#include "([a-z]+)/|#include "\1_|' $BUILD/{src,include}/*/*

rm $BUILD.zip
cd $BUILD
zip $BUILD.zip -r include src
cd -
