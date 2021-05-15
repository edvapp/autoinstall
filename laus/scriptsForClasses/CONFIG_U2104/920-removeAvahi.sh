#! /bin/bash

. /etc/default/laus-setup

## remove avahi-daemon, because we don't want automatic 
## installation of bonjour printers

apt-get -y purge avahi-daemon

