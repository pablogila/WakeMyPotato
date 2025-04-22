#!/bin/bash

systemctl stop keepalive.timer
systemctl disable keepalive.timer

rm -rf /etc/systemd/system/keepalive.*
rm -rf /usr/local/sbin/keepalive.sh

systemctl daemon-reload
