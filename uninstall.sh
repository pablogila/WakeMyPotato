#!/bin/bash

echo 'Removing WakeMyPotato...'

systemctl stop wmp.timer
systemctl disable wmp.timer

rm -rf /etc/systemd/system/wmp.*
rm -rf /usr/local/sbin/wmp.sh

systemctl daemon-reload
