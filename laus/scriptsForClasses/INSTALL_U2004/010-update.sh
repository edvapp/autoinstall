#! /bin/bash


## we create /etc/apt/apt.conf 
## the same way a 
## pxe - preseed 
## installation creats its files

if [ ! -f /etc/apt/apt.conf ] ;
then
	echo 'Acquire::http { Proxy "http://apca01:3142"; };' > /etc/apt/apt.conf
	chmod 644 /etc/apt/apt.conf
fi

## ONE single update here for all following packages
apt-get -y update

