#!/bin/bash

# create 
# desktop-file : /etc/xdg/autostart/app-makeDesktopLinkForTestees.desktop
# with link to 
# shell-script : /usr/local/bin/makeDesktopLinkForTestees.sh
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Testee Desktop Links
Name[de]=Skript zum Erstellen der Desktop Links für Testee Benutzer
Exec=/usr/local/bin/makeDesktopLinkForTestees.sh
Terminal=false
X-GNOME-Autostart-Phase=Applications
NoDisplay=true
" >> /etc/xdg/autostart/app-makeDesktopLinkForTestees.desktop

# copy shell script to: /usr/local/bin/makeDesktopLinkForTestees.sh
cp files/makeDesktopLinkForTestees.sh /usr/local/bin/makeDesktopLinkForTestees.sh

chmod a+x /usr/local/bin/makeDesktopLinkForTestees.sh

