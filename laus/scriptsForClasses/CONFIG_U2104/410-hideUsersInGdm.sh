#!/bin/bash

file="/etc/gdm3/greeter.dconf-defaults"
if ! [ -f $file".original" ];
then
	cp $file $file".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=$file".laus."$updatetime
cp $file $newfile

## enable settings for login screen
sed -e "{
	/login-screen/ s/#//
}" -i $file

## hide user list, so once logged in ldap-user do not appear on the login screen
sed -e "{
	/# disable-user-list=true/ s/# disable-user-list=true/disable-user-list=true/
}" -i $file


