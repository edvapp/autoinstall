#!/bin/bash

# Source Laus-Settings
. /etc/default/laus-setup

apt-get -y update

## make Virtualbax-Extensionpack update-able per laus-script
rm /var/log/laus/ALLCLASSES.INSTALL_U2004.121-installVirtualBoxExtensionpack.sh

apt-get -y dist-upgrade

apt-get -y autoremove
