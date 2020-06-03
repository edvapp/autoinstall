#!/bin/bash

# Source Laus-Settings
. /etc/default/laus-setup

# create desktop file in: 
# /usr/share/applications
# Intelli Java IDE Community
DESKTOPFILE=IntelliJavaIDE.desktop
DESKTOPFILEPATH=/usr/share/applications

echo "[Desktop Entry]
Encoding=UTF-8
Name=Intelli Java IDE Community
Name[de_AT]=Intelli Java IDE Community
Comment= Python IDE with Learning Program
Exec=/home/shares/optProgs/Informatik/idea-IC/bin/idea.sh
Icon=/home/shares/optProgs/Informatik/idea-IC/bin/idea.png
Categories=Application
Version=1.0
Type=Application
Terminal=0
" > $DESKTOPFILEPATH/$DESKTOPFILE

