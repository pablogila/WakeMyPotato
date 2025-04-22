#!/bin/bash

cp keepalive.timer keepalive.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable keepalive.timer
systemctl start keepalive.timer

echo "Installed keepalive service"
