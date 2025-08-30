#!/bin/bash

echo ""
echo "Welcome to the WakeMyPotato installer!"
echo "https://github.com/pablogila/WakeMyPotato"
echo ""

# Check if the installation is run as root
if [ "$EUID" -ne 0 ]; then
  echo "!!! ABORTING: You must be root! Install as:" >&2
  echo "sudo bash install.sh" >&2
  echo ""
  exit 1
fi

# Check if powermgmt-base is installed
if ! dpkg -s "upower" > /dev/null 2>&1; then
    echo ""
    echo "!!! ABORTING: missing package 'upower'" >&2
    echo "Please install it before running the installation script:" >&2
    echo "sudo apt install upower" >&2
    echo ""
    exit 1
fi

echo "Enter seconds to wake up after a blackout,"
echo "leave empty to use the default 600 seconds:"
read -p "> " waketime

if [[ -z "$waketime" ]]; then
    waketime=600
fi
if [[ ! "$waketime" =~ ^[0-9]+$ ]]; then
    echo ""
    echo "!!! ABORTING: Invalid input, please enter a positive integer!" >&2
    echo ""
    exit 1
fi

cp src/wmp.timer src/wmp.service /etc/systemd/system/
chmod 644 /etc/systemd/system/wmp.timer /etc/systemd/system/wmp.service
cp src/wmp src/wmp-run /usr/local/sbin/
chmod 744 /usr/local/sbin/wmp /usr/local/sbin/wmp-run

# Set custom wake time in service file
sed -i "s|^ExecStart=.*|ExecStart=/usr/local/sbin/wmp-run $waketime|" /etc/systemd/system/wmp.service

# Check if AC is being used right now, if not don't enable the service yet!
if ! upower -i $(upower -e | grep 'line_power') | grep -q 'online:\s*yes'; then
    echo ""
    echo "!!! WARNING: AC power is NOT connected right now!" >&2
    echo "WakeMyPotato was installed but NOT enabled." >&2
    echo "Make sure to connect AC before starting the service with:" >&2
    echo "sudo wmp start" >&2
    echo ""
    echo "Use 'sudo wmp help' for more info on user commands."
    echo ""
    exit 0
fi

systemctl daemon-reload
systemctl enable wmp.timer
systemctl start wmp.timer

echo ""
echo "WakeMyPotato is installed and running!"
echo "Use 'sudo wmp help' for info on user commands."
echo ""
