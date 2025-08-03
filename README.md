# WakeMyPotato

WakeMyPotato is a simple and last-resort systemd Linux service
to keep your old potato laptop alive in the event of a power failure.

Some old machines lack Wake-On-Lan (WOL) or BIOS boot timers,
making it difficult to reuse them as home servers.
This service programs an rtcwake call in the near future and safely powers down the laptop if AC fails.
If present, it will safely and forcefully power off RAID HDDs to prevent mechanical wear.
It will attempt to boot once power is restored.

This method is not ideal and may fail if the battery gets depleted,
so it should be considered as a last-resort option for old devices
without WOL nor automatic BIOS wake support.

Install from the downloaded `WakeMyPotato/` folder with:
```shell
sudo bash install.sh
```

It will prompt you to enter the number of seconds to wake after a blackout.
600 seconds (10 minutes) should be enough for most cases.

Check that the service is running:
```shell
systemctl status wmp.timer
```

Uninstall with:
```shell
sudo bash uninstall.sh
```

To update, simply uninstall before installing again.

Any suggestions? Please let me know! :D
