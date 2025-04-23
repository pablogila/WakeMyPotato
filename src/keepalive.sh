#!/bin/bash
# This script is part of the KeepAlive systemd service.
# https://github.com/pablogila/KeepAlive
# It will safely power off RAID disks before an emergency shutdown on AC outage.
# The system is automatically restored after 10 minutes or once power is back.

ac_status=$(on_ac_power; echo $?)
if [ "$ac_status" -eq 0 ]; then
    rtcwake -m no -s 600
else
    echo -e 'Emergency shutdown on AC power outage!\nThe service will try to restart automatically in 10 minutes...' | wall
    echo 'Emergency shutdown on AC power outage!' | systemd-cat -p 'alert' -t 'keepalive'
    # Safely force unmount and power-off RAID HDDs
    mdadm --detail --scan | while read -r line; do
        raid_dev=$(echo "$line" | awk '{print $2}' | cut -d'=' -f1 | tr -d '[]')
        if ! mdadm --detail "$raid_dev" &>/dev/null; then
            continue  # Ignore inactive RAID
        fi
        mount_point=$(findmnt -n -o TARGET "$raid_dev" 2>/dev/null)
        if [ -n "$mount_point" ]; then
            # Kill processes using the RAID
            #echo fuser -km "$mount_point" | systemd-cat -t 'keepalive'
            #fuser -km "$mount_point" || echo "Failed to kill processes on $mount_point" | systemd-cat -p 'warning' -t 'keepalive'
            sync; sleep 1
            # Unmount the RAID
            echo umount -f "$mount_point" | systemd-cat -t 'keepalive'
            umount -f "$mount_point" || echo "Failed to force unmount $mount_point" | systemd-cat -p 'warning' -t 'keepalive'
        fi
        echo mdadm --stop "$raid_dev" | systemd-cat -t 'keepalive'
        # Stop the RAID
        mdadm --stop "$raid_dev" || echo "Failed to stop $raid_dev" | systemd-cat -p 'warning' -t 'keepalive'
        # Safely power off the individual disks
        disks=$(mdadm --detail "$raid_dev" 2>/dev/null | 
                awk '/active sync/ && $0 !~ /spare/ {print $NF}' | sort -u)
        for disk in $disks; do
            echo udisksctl power-off -b "$disk" | systemd-cat -t 'keepalive'
            udisksctl power-off -b "$disk" || echo "Failed to power-off $disk" | systemd-cat -p 'warning' -t 'keepalive'
        done
    done
    # Safely power off the system for 10 minutes or until AC is back
    echo 'Shutting down NOW' | systemd-cat -p 'alert' -t 'keepalive'
    echo rtcwake -m off -s 60 | systemd-cat -t 'keepalive'
    rtcwake -m off -s 60
fi
