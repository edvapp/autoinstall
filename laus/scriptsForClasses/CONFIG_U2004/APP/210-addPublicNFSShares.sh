#!/bin/bash

# quiet installation
export DEBIAN_FRONTEND=noninteractive

apt-get -y install nfs-common autofs

## in 16.04 
## /etc/default/nfs-common
## NEED_GSSD=yes
## was needed
## laus configuration in APP1604


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
# NFS - directory for public shares
# 1. lehrmaterial	->	NFS - Share, where teachers place material for pupils read only
# 2. schueler		->	NFS - Share, read - write for everybody
# 3. optProg		->	NFS - Share, for programms starting from networkshare e.g. Android Studio, ...
/home/shares	/etc/auto.shares	--ghost

" >> /etc/auto.master


## create config file for /home/shares
echo "
lehrmaterial	-fstype=nfs4	nfs02:/lehrmaterial

schueler		-fstype=nfs4	nfs03:/schueler

optProgs		-fstype=nfs4	nfs04:/optProgs
" > /etc/auto.shares

systemctl restart autofs
