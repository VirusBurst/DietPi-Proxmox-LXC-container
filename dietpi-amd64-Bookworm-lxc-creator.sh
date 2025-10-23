#!/bin/bash
set -e

# Variables
URL="https://dietpi.com/downloads/images/DietPi_NativePC-BIOS-x86_64-Bookworm.img.xz"
IMGXZ="/tmp/DietPi_NativePC-BIOS-x86_64-Bookworm.img.xz"
IMG="/tmp/DietPi_NativePC-BIOS-x86_64-Bookworm.img"
MOUNTDIR="/mnt/dietpi-img"
TEMPLATE="/var/lib/vz/template/cache/dietpi-BIOS-Bookworm-$(date +%d_%m_%Y).tar.zst"

# Download
wget -O "$IMGXZ" "$URL"

# Unpack
xz -d -k "$IMGXZ" -c > "$IMG"

# Loop-Device and chk which file
losetup -Pf "$IMG"
LOOP=$(losetup -a | grep "$IMG" | awk '{print $1}' | cut -d: -f1)

# mount
mkdir -p "$MOUNTDIR"
mount "${LOOP}p1" "$MOUNTDIR"

# Kill pesky DietPi CloudShell
rm -f /mnt/dietpi-img/etc/systemd/system/multi-user.target.wants/dietpi-cloudshell.service
rm -f /mnt/dietpi-img/etc/systemd/system/dietpi-cloudshell.service

# Tarball w/ zstd REcompress
tar --numeric-owner --xattrs -I zstd -cf "$TEMPLATE" -C "$MOUNTDIR" .

# cleanup
umount "$MOUNTDIR"
losetup -d "$LOOP"
rm "$IMGXZ" "$IMG"
rm -r "$MOUNTDIR"

echo "Template created: $TEMPLATE"
