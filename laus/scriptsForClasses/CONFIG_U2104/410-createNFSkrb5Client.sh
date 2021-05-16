#!/bin/bash


# manipulated file
file="/etc/default/nfs-common"
if ! [ -f ${file}".original" ];
then
        cp ${file} ${file}".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=${file}".laus."${updatetime}
cp ${file} ${newfile}

# single quotes because double qutes inside !
sed -e '{
	/NEED_GSSD=$/ s/NEED_GSSD=/NEED_GSSD="yes"/
}' -i $file




