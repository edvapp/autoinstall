#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

## hide printers
## edit /etc/avahi/avahi-daemon.conf with sed
#### replace use-ipv4=yes with use-ipv4=no
#### replace use-ipv6=yes with use-ipv6=no
#### manually add printers in preferences devices printers (sudo account eg. worker)
#### reboot
#### only the manually installed printers should be visible ;-)
sed -i 's/use-ipv4=yes/use-ipv4=no/g' /etc/avahi/avahi-daemon.conf
sed -i 's/use-ipv6=yes/use-ipv6=no/g' /etc/avahi/avahi-daemon.conf

