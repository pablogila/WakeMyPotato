#!/bin/bash

echo "Welcome to the WakeMyPotato installer!"

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service
cp src/wmp.sh /usr/local/sbin/wmp.sh
chmod 744 /usr/local/sbin/wmp.sh

echo "Enter seconds to wake up after a blackout,"
echo "leave empty to use the default 600 seconds:"
read -p "> " timeout

if [[ -z "$timeout" ]]; then
    timeout=600
fi
if [[ "$timeout" =~ ^[0-9]+$ ]]; then
    echo "ExecStart=/usr/local/sbin/wmp.sh $timeout" >> /etc/systemd/system/wmp.service
else
    echo "Invalid input, please enter a positive integer! Aborting..."
    rm -rf /etc/systemd/system/wmp.*
    rm -rf /usr/local/sbin/wmp.sh
    exit 1
fi

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer

echo "WakeMyPotato installed succesfully!"
echo "To check the status:    systemctl status wmp.timer"
echo "To remove the service:  sudo bash uninstall.sh"
