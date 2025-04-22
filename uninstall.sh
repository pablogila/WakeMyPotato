#!/bin/bash

systemctl stop keepalive.timer
systemctl disable keepalive.timer
rm -r /etc/systemd/system/keepalive.timer /etc/systemd/system/keepalive.service
systemctl daemon-reload
