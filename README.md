# KeepAlive

KeepAlive is a simple and last-resort systemd Linux service
to keep your old potato laptop alive in the event of a power failure.

Some old machines lack Wake-On-Lan (WOL) or BIOS boot timers,
making it difficult to reuse them as home servers.
This service programs an rtcwake call in the next 15 minutes and safely powers down the laptop if AC fails.
If present, it will safely and forcefully power off RAID HDDs to prevent mechanical wear.
It will attempt to boot once power is restored.

This method is not ideal and may fail if the battery gets depleted,
so it should be considered as a last-resort option for old devices
without WOL or BIOS timers support.

Install from the downloaded `KeepAlive/` folder with:
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

To update, simply uninstall before installing again.

Any suggestions? Please let me know! :D
