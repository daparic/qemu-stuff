#!/bin/sh
#

LIST=list.txt
nl $LIST
read -p "? " var
url=$(sed -n ${var}p $LIST)
img=$(basename $url)

[ ! -e $img ] && wget $url || true
[ $? -ne 0 ] && exit 1
 
qemu-system-aarch64 \
    -m 2048 \
    -cpu cortex-a72 \
    -smp 4 \
    -M virt \
    -nographic \
    -bios QEMU_EFI.fd \
    -drive if=none,file=$img,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -drive file=user-data.img,format=raw \
    -device virtio-net-device,netdev=net0 \
    -netdev user,hostfwd=tcp:127.0.0.1:2222-:22,id=net0
