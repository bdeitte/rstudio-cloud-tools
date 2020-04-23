#!/bin/bash
set -ex

DISK_MNT=${DISK_MNT:-/mnt/rstudio}
MNT_USER=${MNT_USER:-rstudio}
MNT_GROUP=${MNT_GROUP:-rstudio}

# In Azure, /dev/sdb is ephemeral storage mapped to /mnt/resource.
# Additional disks are mounted after that...
DISK_NAME=/dev/sdc
DISK_PART=${DISK_NAME}1

function partition_disk {
    parted $DISK_NAME mklabel msdos
    parted -s $DISK_NAME mkpart primary ext4 0% 100%
    mkfs -t ext4 $DISK_PART
}

mkdir -p $DISK_MNT
lsblk -no FSTYPE $DISK_NAME | grep ext4 || partition_disk
mount $DISK_PART $DISK_MNT
chown $MNT_USER:$MNT_GROUP $DISK_MNT
echo "$DISK_PART $DISK_MNT ext4 defaults 0 0" >> /etc/fstab
