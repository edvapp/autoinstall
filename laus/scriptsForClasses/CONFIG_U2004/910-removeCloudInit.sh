#! /bin/bash

. /etc/default/laus-setup


# remove cloud-init, if machine was installed via ubuntu-server-installer
if [ -d /etc/cloud/ ];
then
        apt-get -y purge cloud-init

        rm -rf /etc/cloud/
        rm -rf /var/lib/cloud/
fi

