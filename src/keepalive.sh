#!/bin/bash
# This script is part of the KeepAlive systemd service.
# https://github.com/pablogila/KeepAlive
# It will safely power off RAID disks before an emergency shutdown on AC outage.
# The system is automatically restored after 15 minutes or once power is back.

ac_status=$(on_ac_power; echo $?)
if [ "$ac_status" -eq 0 ]; then
    rtcwake -m no -s 900
else
    echo 'Emergency shutdown on AC power outage!' | systemd-cat -p 'alert' -t 'keepalive'
    # Safely force unmount and power-off RAID HDDs
    for raid in $(mdadm --detail --scan | awk '{print $2}'); do
        disks=$(mdadm --examine $raid 2>/dev/null | grep "dev/" | awk '{print $NF}')
        mount_point=$(findmnt -n -o TARGET $raid 2>/dev/null)
        if [ -n "$mount_point" ]; then
            fuser -km $mount_point || true
            umount -f $mount_point || true
        fi
        mdadm --stop $raid || true
        for disk in $disks; do
            udisksctl power-off -b $disk || true
        done
    done
    # Power off the machine for 15 minutes
    rtcwake -m off -s 900
fi
