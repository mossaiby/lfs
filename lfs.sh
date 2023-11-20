#!/bin/bash

set -e

# Versions

KERNEL_VERSION=6.1.1
BUSYBOX_VERSION=1.36.1

# No. of compile jobs

TASKS=8

# Kernel

if [ ! -f linux-$KERNEL_VERSION.tar.xz ]; then

  KERNEL_VERSION_MAJOR=$(echo $KERNEL_VERSION | cut -d. -f1)
  wget https://cdn.kernel.org/pub/linux/kernel/v$KERNEL_VERSION_MAJOR.x/linux-$KERNEL_VERSION.tar.xz

fi;

rm -rf linux-$KERNEL_VERSION
tar xf linux-$KERNEL_VERSION.tar.xz

cd linux-$KERNEL_VERSION

  make defconfig
  make -j$TASKS

cd ..

# Busybox

if [ ! -f busybox-$BUSYBOX_VERSION.tar.bz2 ]; then

  wget https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2

fi

rm -rf busybox-$BUSYBOX_VERSION
tar xf busybox-$BUSYBOX_VERSION.tar.bz2

cd busybox-$BUSYBOX_VERSION

  make defconfig

  # Enable static linking
  echo 'CONFIG_STATIC=y' >> .config

  make -j$TASKS

cd ..

# Boot and initial RAM disk

cp linux-$KERNEL_VERSION/arch/x86_64/boot/bzImage .
cp busybox-$BUSYBOX_VERSION/busybox .

rm -rf initrd

mkdir initrd
cd initrd

  mkdir bin dev proc sys

  cd bin

    cp ../../busybox .

    # Create shortcuts

    for prog in $(./busybox --list); do

      ln -s /bin/busybox ./$prog

    done

  cd ..

  cp ../init .

  cp ../init .
  chmod -R 777 .
  find . | cpio -o -H newc > ../initrd.img

cd ..