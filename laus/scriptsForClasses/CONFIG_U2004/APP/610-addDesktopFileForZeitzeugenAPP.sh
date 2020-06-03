#!/bin/bash

# Source Laus-Settings
. /etc/default/laus-setup

# create desktop file in: 
# /usr/share/applications
# for Zeitzeugen APP
DESKTOPFILE=Zeitzeugen.desktop
DESKTOPFILEPATH=/usr/share/applications

echo "[Desktop Entry]
Categories=Utility;APP
Comment[de]=Zeitzeugen APP
Comment=Zeitzeugen APP
Exec=wine /home/shares/lehrmaterial/Geschichte/Zeitzeugen/Zeitzeugen-x64
GenericName[de]=Zeitzeugen APP
GenericName=Zeitzeugen APP
Icon=/home/shares/lehrmaterial/Geschichte/Zeitzeugen/Zeitzeugen.png
MimeType=
Name[de]=Zeitzeugen APP
Name=Zeitzeugen APP
Path=/home/shares/lehrmaterial/Geschichte/Zeitzeugen
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

