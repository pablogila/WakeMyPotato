#!/bin/bash

echo "  Welcome to the WakeMyPotato installer!"

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service
cp src/wmp src/wmp-run /usr/local/sbin/
chmod 744 /usr/local/sbin/wmp /usr/local/sbin/wmp-run

echo "  Enter seconds to wake up after a blackout,"
echo "  leave empty to use the default 600 seconds:"
read -p "  > " timeout

if [[ -z "$timeout" ]]; then
    timeout=600
fi
if [[ ! "$timeout" =~ ^[0-9]+$ ]]; then
    echo "  Invalid input, please enter a positive integer! Aborting..."
    rm -rf /etc/systemd/system/wmp.*
    rm -rf /usr/local/sbin/wmp /usr/local/sbin/wmp-run
    exit 1
fi

echo "  Does your device have a battery that lasts at least 2 minutes?"
echo "  this will enable the emergency shutdown"
echo "  to prevent mechanical wear on HDDs (y/n)"
read -p "  > " battery

if [[ -z "$battery" ]]; then
    battery='y'
fi
if [ "$battery" = 'n' ]; then
    sed -i "s|^ExecStart=.*|ExecStart=/usr/local/sbin/wmp-run $timeout n|" /etc/systemd/system/wmp.service
elif [ "$battery" = 'y' ]; then
    sed -i "s|^ExecStart=.*|ExecStart=/usr/local/sbin/wmp-run $timeout y|" /etc/systemd/system/wmp.service
else
    echo "  Invalid input, please enter 'y' or 'n'! Aborting..."
    rm -rf /etc/systemd/system/wmp.*
    rm -rf /usr/local/sbin/wmp /usr/local/sbin/wmp-run
    exit 1
fi

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer

echo "  WakeMyPotato installed succesfully!"
echo "  Use 'wmp help' for info on user commands."
