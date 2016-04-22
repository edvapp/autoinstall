#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

######Arduino##########################################################
#http://labs.arduino.org/Arduino%20IDE%20on%20Linux-based%20OS
cd /tmp/
wget http://download.arduino.org/IDE/1.7.10/arduino-1.7.10.org-linux64.tar.xz
tar -xvf arduino-1.7.10.org-linux64.tar.xz
cp arduino-1.7.10-linux64 /usr/lib/arduino-1.7.10-linux64
ln /usr/lib/arduino-1.7.10-linux64/arduino /usr/bin/arduino

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

apt-get -y install -f 
apt-get remove -f modemmanager

cd /usr/local/share/
wget http://www.arduino.org/images/home/Arduino.png

#finder entry and icon 
echo "
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Arduino
Comment=Arduino
Exec=/usr/bin/arduino
Icon=/usr/local/share/Arduino.png
Terminal=false
" >> /usr/share/applications/arduino.desktop


#####S4A##############################################################
# http://s4a.cat/
cd /tmp
wget http://vps34736.ovh.net/S4A/S4A16.deb

dpkg --add-architecture i386
apt-get update
apt-get -y install ia32-libs

dpkg -i --force-architecture S4A16.deb

## bring Firmaware to desktop
cd /home/worker/Schreibtisch/
wget http://vps34736.ovh.net/S4A/S4AFirmware16.ino

#reboot
