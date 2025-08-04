# WakeMyPotato

WakeMyPotato (WMP) is a simple and last-resort systemd Linux service
to keep your old potato laptop alive in the event of a power failure.

Some old machines lack Wake-On-Lan (WOL) or BIOS boot timers,
making it difficult to reuse them as home servers.
This service programs an rtcwake call in the near future and safely powers down the laptop if AC fails.
If present, it will safely and/or forcefully power off RAID HDDs to prevent mechanical wear.
It will attempt to boot once power is restored, after a specified waiting time.
Note that in principle it should work even if AC power takes longer to restore.
If the system has no battery at all, it will simply power off (obviously)
and it will try to boot automatically later.

This method is not ideal and may fail if the BIOS CMOS battery is too old or empty.
This should be considered as a last-resort option for old devices
without WOL nor automatic BIOS wake support.

## Installation

To install WMP, first clone the repository:
```shell
git clone https://github.com/pablogila/WakeMyPotato.git
cd WakeMyPotato
```

And run the installation script:
```shell
sudo bash install.sh
```

It will prompt you to enter the number of seconds to wait before waking up after a blackout.
The default (600 seconds, a.k.a. 10 minutes) should be good for most cases.

You can now check that the service is running:
```shell
systemctl status wmp.timer
```

If you no longer want to use WMP, just run the **uninstall** script:
```shell
sudo bash uninstall.sh
```

To **update**, simply uninstall with your current version before installing the new version.

## System logs

To check the systemd logs:
```shell
sudo journalctl -u wmp -p warning -r
```

## Contribute  

Any suggestions? Issues and PR are well received! :D

## License

> WakeMyPotato: Keep your system alive after power outages  
> Copyright (C) 2025 Pablo Gila-Herranz  
>
> This program is free software: you can redistribute it and/or modify  
> it under the terms of the GNU Affero General Public License as published  
> by the Free Software Foundation, either version 3 of the License, or  
> (at your option) any later version.  
>
> This program is distributed in the hope that it will be useful,  
> but WITHOUT ANY WARRANTY; without even the implied warranty of  
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
> GNU Affero General Public License for more details.  
