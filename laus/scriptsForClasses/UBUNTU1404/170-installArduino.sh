#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


#http://labs.arduino.org/Arduino%20IDE%20on%20Linux-based%20OS

cp -v files/arduino-1.7.10.org-linux64.tar.xz /usr/lib
ln /usr/bin/arduino /usr/lib/arduino-1.7.10-linux64/arduino

# manipulated file
file=/etc/udev/rules.d/90-extraacl.rules

printAndLogMessage "Write to file: " $file
echo "
KERNEL="ttyUSB[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="worker"
KERNEL="ttyACM[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="worker"
" >> $file

logFile $file

usermod -a -G tty worker
usermod -a -G dialout worker

apt-get remove modemmanager

reboot
