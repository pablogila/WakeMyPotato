#!/bin/bash

echo 'Testing KeepAlive shutdown routine...' | wall

##### Safely power-off an optional md0 RAID of HDDs sda and sdb
fuser -km /mnt/md0 || echo "fuse failed" | wall                       # Kill apps using the HDDs
umount -f /mnt/md0 || echo "unmount failed" | wall                    # Force unmount
mdadm --stop /dev/md0 || echo "mdadm failed" | wall                   # Stop the RAID
udisksctl power-off -b /dev/sda || echo "poweroff sda failed" | wall  # Safely poweroff sda
udisksctl power-off -b /dev/sdb || echo "poweroff sdb failed" | wall  # Safely poweroff sdb
#####

rtcwake -m off -s 60
