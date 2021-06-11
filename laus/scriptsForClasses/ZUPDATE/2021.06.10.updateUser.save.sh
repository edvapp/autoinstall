#! /bin/bash

# Source Laus-Settings
. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

rsync -a -u $SOURCE_PATH/user.save.$(lsb_release -r -s)/ /home/user.save

chown root:root /home/user.save 

chmod 770 /home/user.save 


