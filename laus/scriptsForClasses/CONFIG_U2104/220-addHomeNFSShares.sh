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
#
# HOME - directories für teachers BRG
/home/users/701036/l    /etc/auto.users.701036.l        --ghost
#
# HOME - directories für teachers GfB
/home/users/701076/l    /etc/auto.users.701076.l        --ghost
#
# HOME - directories für pupils BRG
/home/users/701036/s    /etc/auto.users.701036.s        --ghost
#
# HOME - directories für pupils GfB
/home/users/701076/s    /etc/auto.users.701076.s        --ghost
#
# HOME - directories für Verwaltung BRG
/home/users/701036/v    /etc/auto.users.701036.v        --ghost
#
# HOME - directories für Verwaltung GfB
/home/users/701076/v    /etc/auto.users.701076.v        --ghost
#
# RETURN - directories für Testees BRG
/home/users/701036/t    /etc/auto.users.701036.t        --ghost
#
# RETURN - directories für Testees GfB
/home/users/701076/t    /etc/auto.users.701076.t        --ghost
#
" >> /etc/auto.master

## sec = krb5
## create config file for teachers BRG
echo "
*	-fstype=nfs4,sec=krb5	ad01f1:/701036/l/&
" > /etc/auto.users.701036.l

## create config file for teachers GfB
echo "
*	-fstype=nfs4,sec=krb5	ad01f1:/701076/l/&
" > /etc/auto.users.701076.l

## create config file for Verwaltung BRG
echo "
*	-fstype=nfs4,sec=krb5	ad01f1:/701036/v/&
" > /etc/auto.users.701036.v

## create config file for Verwaltung GfB
echo "
*	-fstype=nfs4,sec=krb5	ad01f1:/701076/v/&
" > /etc/auto.users.701076.v

## sec != krb5
## create config file for Testees BRG
echo "
*	-fstype=nfs4	fs02:/701036/t/&
" > /etc/auto.users.701036.t

## create config file for Testees GfB
echo "
*	-fstype=nfs4	fs02:/701076/t/&
" > /etc/auto.users.701076.t

## create config file for pupils BRG
echo "
*	-fstype=nfs4    	fs02:/701036/s/&
" > /etc/auto.users.701036.s

## create config file for pupils GfB
echo "
*	-fstype=nfs4    	fs02:/701076/s/&
" > /etc/auto.users.701076.s


systemctl restart autofs
