#!/bin/bash

# DISABLE - ENABLE WWW for Testees

if [[ $USER == testee* ]];
then
	case "$1" in
	start)
		# disable WWW
		# set Policy DROP for chain OUTPUT
		/sbin/iptables -P OUTPUT DROP
		
		# Insert rule ACCEPT for destination 127.0.0.0/24
		/sbin/iptables -I OUTPUT -d 127.0.0.0/24 -j ACCEPT
		
		# Insert rule ACCEPT for destination 10.0.0.0/8
		/sbin/iptables -I OUTPUT -d 10.0.0.0/8 -j ACCEPT
		
		# Insert rule DROP for destination 10.0.0.12 = lehrmaterial
		/sbin/iptables -I OUTPUT -d 10.0.0.12 -j DROP
		;;
	stop)
		# enable WWW
		/sbin/iptables -P OUTPUT ACCEPT
		/sbin/iptables -F
		;;
	esac
fi


