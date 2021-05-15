#!/bin/bash

# Source Laus-Settings
. /etc/default/laus-setup

# create desktop file in: 
# /usr/share/applications
# for Greenfoot
DESKTOPFILE=Greenfoot.desktop
DESKTOPFILEPATH=/usr/share/applications

echo "[Desktop Entry]
Categories=Utility;Application;
Comment[de]=Greenfoot IDE 3.1.0
Comment=Greenfoot IDE 3.1.0
Exec=/home/shares/optProgs/Informatik/greenfoot/greenfoot
GenericName[de]=Greenfoot IDE 3.1.0
GenericName=Greenfoot IDE 3.1.0
Icon=/home/shares/optProgs/Informatik/greenfoot/lib/images/greenfoot-icon-256.png
MimeType=
Name[de]=Greenfoot IDE 3.1.0
Name=Greenfoot IDE 3.1.0
Path=/home/shares/optProgs/Informatik/greenfoot/
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
Version=1.0
X-DBUS-ServiceName=
X-DBUS-StartupType=
X-KDE-SubstituteUID=false
X-KDE-Username=
" > $DESKTOPFILEPATH/$DESKTOPFILE

