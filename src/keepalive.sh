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
            fuser -km "$mount_point" || true  # Kill processes using the RAID
            umount -f "$mount_point" || true  # Force unmount
            echo fuser -km "$mount_point" | systemd-cat -t 'keepalive'
            echo umount -f "$mount_point" | systemd-cat -t 'keepalive'
        fi
        mdadm --stop "$raid_dev" || true  # Stop the RAID
        echo mdadm --stop "$raid_dev" | systemd-cat -t 'keepalive'
        # Safely power off the individual disks
        disks=$(mdadm --detail "$raid_dev" 2>/dev/null | 
                awk '/active sync/ && $0 !~ /spare/ {print $NF}' | sort -u)
        for disk in $disks; do
            udisksctl power-off -b "$disk" || true
            echo udisksctl power-off -b "$disk" | systemd-cat -t 'keepalive'
        done
    done
    # Safely power off the system for 10 minutes or until AC is back
    rtcwake -m off -s 600
    echo rtcwake -m off -s 600 | systemd-cat -t 'keepalive'
fi
