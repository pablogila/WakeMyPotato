#!/bin/bash

echo "  Welcome to the WakeMyPotato installer!"
echo "  Enter seconds to wake up after a blackout,"
echo "  leave empty to use the default 600 seconds:"
read -p "  > " timeout

if [[ -z "$timeout" ]]; then
    timeout=600
fi
if [[ ! "$timeout" =~ ^[0-9]+$ ]]; then
    echo "  Invalid input, please enter a positive integer! Aborting..."
    exit 1
fi

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service
cp src/wmp src/wmp-run /usr/local/sbin/
chmod 744 /usr/local/sbin/wmp /usr/local/sbin/wmp-run

sed -i "s|^ExecStart=.*|ExecStart=/usr/local/sbin/wmp-run $timeout|" /etc/systemd/system/wmp.service

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer

echo "  WakeMyPotato installed succesfully!"
echo "  Use 'sudo wmp help' for info on user commands."
