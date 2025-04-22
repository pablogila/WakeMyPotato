#!/bin/bash
# This script is part of the KeepAlive systemd service.
# It can be extended to send a custom email upon AC outage, etc.
# https://github.com/pablogila/KeepAlive

ac_status=$(on_ac_power; echo $?)
if [ "$ac_status" -eq 0 ]; then
    rtcwake -m no -s 900
else
    echo 'Emergency shutdown on AC power outage!' | systemd-cat -p 'alert' -t 'keepalive'
    rtcwake -m off -s 900
fi
