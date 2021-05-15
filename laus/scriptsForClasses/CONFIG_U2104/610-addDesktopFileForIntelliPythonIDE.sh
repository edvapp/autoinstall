#!/bin/bash

# Source Laus-Settings
. /etc/default/laus-setup

# create desktop file in: 
# /usr/share/applications
# Intelli Python IDE Community
DESKTOPFILE=IntelliPythonIDE.desktop
DESKTOPFILEPATH=/usr/share/applications

echo "[Desktop Entry]
Encoding=UTF-8
Name=PyCharm Community
Name[de_AT]=PyCharm Community
Comment=Python IDE 
Comment[de_AT]=Python Community IDE
Exec=/home/shares/optProgs/Informatik/pycharm-community/bin/pycharm.sh
Icon=/home/shares/optProgs/Informatik/pycharm-community/bin/pycharm.png
Categories=Application
Version=1.0
Type=Application
Terminal=0
" > $DESKTOPFILEPATH/$DESKTOPFILE

