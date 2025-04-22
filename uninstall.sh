#!/bin/bash

systemctl stop keepalive.timer
systemctl disable keepalive.timer

rm -rf /etc/systemd/system/keepalive.*
rm -rf /usr/local/bin/keepalive.sh

systemctl daemon-reload
