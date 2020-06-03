#!/bin/bash

# for use of smbpasswd we need package samba-common-bin
apt-get -y install samba-common-bin

file="/usr/local/bin/changepasswd"

echo '#!/bin/bash
echo "Geben sie bitte Ihren Benutzernamen ein."
read LOGINNAME
smbpasswd -r smb01 -U $LOGINNAME
' >> $file

chown root:root $file
chmod 755 $file
