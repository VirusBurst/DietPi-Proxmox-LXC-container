!/bin/bash
set -e

# Variables
URL="https://dietpi.com/downloads/images/DietPi_Proxmox-x86_64-Trixie.qcow2.xz"
IMGXZ="/tmp/DietPi_Proxmox-x86_64-Trixie.qcow2.xz"
IMG="/tmp/DietPi_Proxmox-x86_64-Trixie.qcow2"
MOUNTDIR="/mnt/dietpi-img"
TEMPLATE="/var/lib/vz/template/cache/dietpi-Proxmox-Trixie-$(date +%d_%m_%Y).tar.zst"

# Download
wget -O "$IMGXZ" "$URL"

# Unpack
echo "Unpacking DietPi Proxmox image..."
xz -d -k "$IMGXZ" -c > "$IMG"

# mount
echo "Creating mountpoint..."
mkdir -p "$MOUNTDIR"
echo "Enable mounting QCOW2 files..."
modprobe nbd
sleep 1
echo "Mount DietPi QCOW2 file..."
qemu-nbd -c /dev/nbd0 $IMG
sleep 1
echo "Make it accessible..."
mount /dev/nbd0p1 "$MOUNTDIR"

# Kill pesky DietPi CloudShell
echo "Kill pesky DietPi CloudShell!!!"
rm -f /mnt/dietpi-img/etc/systemd/system/multi-user.target.wants/dietpi-cloudshell.service
rm -f /mnt/dietpi-img/etc/systemd/system/dietpi-cloudshell.service

# Tarball w/ zstd REcompress
echo "Packing DietPi Proxmox image to LXC image..."
tar --numeric-owner --xattrs -I zstd -cf "$TEMPLATE" -C "$MOUNTDIR" .
echo "DONE :)"

# cleanup
echo "Unmount DietPi Proxmox image..."
umount "$MOUNTDIR"
qemu-nbd -d /dev/nbd0
sleep 1
echo "Disable mounting QCOW2 files..."
rmmod nbd
echo "Garbage removal ^^"
rm "$IMGXZ" "$IMG"
rm -r "$MOUNTDIR"

echo "Template created: $TEMPLATE"t "$MOUNTDIR"
