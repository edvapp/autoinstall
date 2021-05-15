#!/bin/bash

file="/etc/default/grub"
if ! [ -f $file".original" ];
then
	cp $file $file".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=$file".laus."$updatetime
cp $file $newfile


## String ersetzen
sed '/#GRUB_DISABLE_RECOVERY="true"/ s/#GRUB_DISABLE_RECOVERY="true"/GRUB_DISABLE_RECOVERY="true"/' -i $file

update-grub
