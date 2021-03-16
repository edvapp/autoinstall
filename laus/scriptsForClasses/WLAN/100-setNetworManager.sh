#!/bin/bash

cd /etc/netplan

echo "Save original netplan yaml files"
for file in $(ls *yaml); 
do
	if ! [ -f $file".original" ];
	then
		cp $file $file".original"
	fi
	updatetime=$(date +%Y%m%d-%T)
	newfile=$file".laus."$updatetime
	mv $file $newfile
done

echo "# new network - config written by laus
network:
   version: 2
   renderer: NetworkManager
" > 10-network-manager-all.yaml

netplan apply

