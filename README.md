# WakeMyPotato

WakeMyPotato (WMP) is a simple and last-resort systemd Linux service
to keep your old potato laptop alive and running in the event of a power failure.

Some old machines lack Wake-On-Lan (WOL) or BIOS boot timers,
making it difficult to reuse them as home servers.
This service programs automatic rtcwake calls in the near future and safely powers down the laptop if AC fails.
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
Optionally, an IP address can be provided to check the network connectivity,
so that an unsuccessful ping will also trigger the shutdown.

To **uninstall** the service, run `sudo wmp uninstall`.
To **update**, simply uninstall with your current version before installing the new version.

## Usage

The service includes an utility to perform several tasks.
To check all available commands, use `sudo wmp help`.

| Command | Description |
| ------- | ----------- |
| `sudo wmp help`                  | Show all available commands |
| `sudo wmp version`               | Print the software version |
| `sudo wmp status`                | Check the service status |
| `sudo wmp log`                   | View recent warning logs |
| `sudo wmp set <seconds> [<IP>]`  | Set new configuration |
| `sudo wmp check <seconds>`       | Run a manual check now |
| `sudo wmp force <seconds>`       | Force a manual shutdown now |
| `sudo wmp stop`                  | Stop the service |
| `sudo wmp start`                 | Start the service |
| `sudo wmp uninstall`             | Uninstall the service |

## Contribute  

Any suggestions? Issues and PRs are well received! :D

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
