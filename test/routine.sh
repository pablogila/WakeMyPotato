#!/bin/bash

echo 'Testing KeepAlive shutdown routine...'

##### Safely power-off an optional md0 RAID of HDDs sda and sdb
fuser -km /mnt/md0 || echo "fuser failed"                # Kill apps using the HDDs
umount -f /mnt/md0 || echo "unmount failed"                    # Force unmount
mdadm --stop /dev/md0 || echo "mdadm failed"                   # Stop the RAID
udisksctl power-off -b /dev/sda || echo "poweroff sda failed"  # Safely poweroff sda
udisksctl power-off -b /dev/sdb || echo "poweroff sdb failed"  # Safely poweroff sdb
#####

rtcwake -m off -s 60
