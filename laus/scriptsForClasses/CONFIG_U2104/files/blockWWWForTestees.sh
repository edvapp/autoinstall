#!/bin/bash

# DISABLE - ENABLE WWW for Testees

if [[ $USER == testee* ]];
then
	case "$1" in
	start)
		# disable WWW
		/sbin/iptables -P OUTPUT DROP
		/sbin/iptables -I OUTPUT -d 10.0.0.0/8 -j ACCEPT 
		/sbin/iptables -I OUTPUT -d 127.0.0.0/24 -j ACCEPT 
		;;
	stop)
		# enable WWW
		/sbin/iptables -P OUTPUT ACCEPT
		/sbin/iptables -F
		;;
	esac
fi


