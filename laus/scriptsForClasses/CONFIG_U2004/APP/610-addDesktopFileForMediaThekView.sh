#!/bin/bash

## create Desktop-Link vor MediathekView
## programm MediathekView hosted on nfs-share /home/shares/optProgs/Diverses/MediathekView/

DESKTOPFILE=MediathekView.desktop
DESKTOPFILEPATH=/usr/share/applications

echo "[Desktop Entry]
Encoding=UTF-8
Name=Mediathek View
Comment=
Exec=/home/shares/optProgs/Diverses/MediathekView/MediathekView.sh
Icon=/home/shares/optProgs/Diverses/MediathekView/MediathekView.ico
Categories=Application
Version=1.0
Type=Application
Terminal=0
Name[de_AT]=Mediathek View
" > $DESKTOPFILEPATH/$DESKTOPFILE
