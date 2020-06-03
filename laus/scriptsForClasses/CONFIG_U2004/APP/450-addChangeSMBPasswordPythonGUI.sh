#!/bin/bash

# for use of smbpasswd we need package samba-common-bin
# for use of tkinter (TK-python bridge) we need package python3-tk
apt-get -y install samba-common-bin python3-tk

## copy python file
cp -v files/ChangeSMBPassword.py 	/usr/local/bin/
chown root:root /usr/local/bin/ChangeSMBPassword.py
chmod 755 /usr/local/bin/ChangeSMBPassword.py


## create desktop file for use in Desktop-Manager
## in /usr/share/applications/ChangeSMBPassword.desktop

echo "[Desktop Entry]
#Version=1.0
Type=Application

Name=APP Samba & Linux Password change
Name[de_AT]=APP Samba & Linux Password ändern

Comment=Change Password APP network
Comment[de]=Passwort im APP Netzwerk ändern

GenericName=ChangeSMBPassword

Keywords=Password
Keywords[de]=Passwort

Exec=/usr/local/bin/ChangeSMBPassword.py

Terminal=false

Icon=seahorse

Categories=Utility
StartupNotify=false
" > /usr/share/applications/ChangeSMBPassword.desktop

chown root:root /usr/share/applications/ChangeSMBPassword.desktop
chmod 755 /usr/share/applications/ChangeSMBPassword.desktop

