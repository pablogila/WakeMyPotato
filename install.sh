#!/bin/bash

echo 'Installing WakeMyPotato...'

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service

read -p "Enter seconds to wake up after a blackout: " timeout

if [[ "$timeout" =~ ^[0-9]+$ ]]; then
    echo "ExecStart=/usr/local/sbin/wmp.sh $timeout" >> /etc/systemd/system/wmp.service
else
    echo "Invalid input. Please enter a positive integer."
    exit 1
fi

cp src/wmp.sh /usr/local/sbin/wmp.sh
chmod 744 /usr/local/sbin/wmp.sh

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer
