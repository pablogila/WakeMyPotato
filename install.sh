#!/bin/bash

echo 'Installing KeepAlive...'

cp src/keepalive.timer src/keepalive.service /etc/systemd/system/
chmod 644 /etc/systemd/system/keepalive.timer /etc/systemd/system/keepalive.service

cp src/keepalive.sh /usr/local/sbin/keepalive.sh
chmod 744 /usr/local/sbin/keepalive.sh

systemctl daemon-reload
systemctl enable keepalive.timer
systemctl start keepalive.timer
