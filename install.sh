#!/bin/bash

echo "  Welcome to the WakeMyPotato installer!"

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service
cp src/wmp src/wmp-run /opt/wmp/
chmod 744 /opt/wmp/*

echo "  Enter seconds to wake up after a blackout,"
echo "  leave empty to use the default 600 seconds:"
read -p "  > " timeout

if [[ -z "$timeout" ]]; then
    timeout=600
fi
if [[ ! "$timeout" =~ ^[0-9]+$ ]]; then
    echo "  Invalid input, please enter a positive integer! Aborting..."
    rm -rf /etc/systemd/system/wmp.*
    rm -rf /opt/wmp
    exit 1
fi

echo "  Does your device have a battery that lasts at least 2 minutes?"
echo "  this will enable the emergency shutdown"
echo "  to prevent mechanical wear on HDDs (y/n)"
read -p "  > " battery

if [[ -z "$battery" ]]; then
    battery='y'
fi
if [ "$battery" -eq 'n' ]; then
    sed -i "s|^ExecStart=.*|ExecStart=/opt/wmp/wmp-run $timeout n|" /etc/systemd/system/wmp.service
elif [ "$battery" -eq 'y' ]; then
    sed -i "s|^ExecStart=.*|ExecStart=/opt/wmp/wmp-run $timeout y|" /etc/systemd/system/wmp.service
else
    echo "  Invalid input, please enter 'y' or 'n'! Aborting..."
    rm -rf /etc/systemd/system/wmp.*
    rm -rf /opt/wmp
    exit 1
fi

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer

echo "WakeMyPotato installed succesfully!"
echo "To check the status:    systemctl status wmp.timer"
echo "To check the logs:      sudo journalctl -u wmp -p warning -r"
echo "To remove the service:  sudo bash uninstall.sh"
