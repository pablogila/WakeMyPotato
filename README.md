# KeepAlive

KeepAlive is a simple and last-resort systemd service to keep your old potato laptop alive.

Some old machines lack Wake-On-Lan (WOL) or BIOS boot timers,
making it difficult to reuse them as home servers.
This service programs an rtcwake call in the next 2 hours and powers down the laptop if AC fails.
It will attempt to boot until power is restored.
This method is not ideal and may fail if the battery gets depleted, but at least is something.

Install with:
```shell
sudo bash install.sh
```

Check that the service is running:
```shell
systemctl status keepalive.timer
```

Uninstall with:
```shell
sudo bash uninstall.sh
```

To update, uninstall before installing again.

Any suggestions? Please let me know! :D
