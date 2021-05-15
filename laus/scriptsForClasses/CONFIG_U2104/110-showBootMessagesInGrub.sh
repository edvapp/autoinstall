#! /bin/bash

. /etc/default/laus-setup


########################################
## Disable plymouth boot screen
########################################
file="/etc/default/grub"
if ! test -f $file".original"; then
	cp $file $file".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=$file".laus."$updatetime
cp $file $newfile

## replace String
sed '/GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"/ s/GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/' -i $file

update-grub

