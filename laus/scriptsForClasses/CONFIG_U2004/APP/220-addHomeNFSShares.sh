#!/bin/bash

# quiet installation
export DEBIAN_FRONTEND=noninteractive

apt-get -y install nfs-common autofs

## Configuration autofs
file="/etc/auto.master"
if ! [ -f $file".original" ];
then
	cp $file $file".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=$file".laus."$updatetime
cp $file $newfile


## append path of config files
## for auto mountpoints to /etc/auto.master
echo "
# HOME - directories für teachers
/home/teachers	/etc/auto.teachers	--ghost

# HOME - directories für pupils
/home/pupils	/etc/auto.pupils	--ghost
" >> /etc/auto.master


## create config file for /home/teachers
echo "
*		-fstype=nfs4	smb01:/teachers/&
" > /etc/auto.teachers


## create config file for /home/pupils
echo "
*		-fstype=nfs4	smb01:/pupils/&
" > /etc/auto.pupils


systemctl restart autofs
