#!/bin/bash

. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

## create shell file, which cleans lost user dirs in /media/...
## in /usr/local/bin
## IMPORTANT: #!/bin/bash has to be in FIRST LINE
echo "#!/bin/bash

rmdir /media/*
" > /usr/local/bin/cleanUsbMountpoint.sh

chmod -R 755 /usr/local/bin/cleanUsbMountpoint.sh


## create service file, which starts clean /media/... service 
## in /lib/systemd/system
echo "[Unit]
Description=Clean unused directories in USB mountpoint /media
Requires=local-fs.target
After=local-fs.target

[Service]
Type=simple
ExecStart=/usr/local/bin/cleanUsbMountpoint.sh

[Install]
WantedBy=multi-user.target

" > /lib/systemd/system/clean-usb-mountpoint.service

systemctl enable clean-usb-mountpoint.service

