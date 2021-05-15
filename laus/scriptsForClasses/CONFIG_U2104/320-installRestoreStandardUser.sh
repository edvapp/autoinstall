#!/bin/bash

. /etc/default/laus-setup
SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

## create shell file in /usr/local/bin,
## which restores standard user
echo "#!/bin/bash

# Restore Standard - User
# replace standard user configuration with saved version

rsync -a --delete --chown=user:root /home/user.save/ /home/user/

# set Displayname back to user, if it has been changed
sed '/user:x:3101/ s/user:x:3101.*/user:x:3101:2000:user:\/home\/user:\/bin\/bash/' -i /etc/passwd

" > /usr/local/bin/restoreStandardUser.sh

chmod 755 /usr/local/bin/restoreStandardUser.sh


## create service file, which starts restores standard user service
## in /lib/systemd/system
echo "[Unit]
Description=Restore Standard User service
Requires=local-fs.target
After=local-fs.target
Before=laus.service

[Service]
Type=simple
ExecStart=/usr/local/bin/restoreStandardUser.sh

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/restore-standard-user.service

chmod 755 /lib/systemd/system/restore-standard-user.service

systemctl enable restore-standard-user.service


## copy & set rights for standard user profile
cp -p -R $SOURCE_PATH/user.save.$(lsb_release -r -s) /home/user.save

chown -R root:root /home/user.save 

chmod -R 770 /home/user.save 
