#!/bin/bash

echo 'Installing WakeMyPotato...'

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service

cp src/wmp.sh /usr/local/sbin/wmp.sh
chmod 744 /usr/local/sbin/wmp.sh

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer
