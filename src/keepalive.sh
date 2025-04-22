#!/bin/bash
# This script is part of the KeepAlive systemd service
# Same functionality as using on keepalive.service:
# ExecStart=on_ac_power && rtcwake -m no -s 7200 || rtcwake -m off -s 7200
# This bash script can be extended to send an email upon AC outage, etc.

ac_status=$(on_ac_power; echo $?)
if [ "$ac_status" -eq 0 ]; then
    rtcwake -m no -s 60
else
    rtcwake -m off -s 60
fi
