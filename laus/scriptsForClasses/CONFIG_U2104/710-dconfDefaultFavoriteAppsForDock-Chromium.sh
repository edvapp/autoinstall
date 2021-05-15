#!/bin/bash

############################################
## check for dconf structure               #
############################################
PROFIL_DIR="/etc/dconf/profile"
PROFIL_FILE="user"

DATABASE_DIR="/etc/dconf/db"
SYSTEM_DB="defaults"
SYSTEM_DB_SUBDIR=${SYSTEM_DB}.d

## create profil file $PROFIL_DIR/$PROFIL_FILE
if [ ! -f ${PROFIL_DIR}/${PROFIL_FILE} ];
then
echo "user-db:user
system-db:$SYSTEM_DB
" > ${PROFIL_DIR}/${PROFIL_FILE}
fi

## create db - directories
if [ ! -d ${DATABASE_DIR}/db/${SYSTEM_DB_SUBDIR} ];
then
	mkdir -p ${DATABASE_DIR}/${SYSTEM_DB_SUBDIR}
fi

############################################
## make dconf entry                        #
############################################
FILE="org.gnome.shell.favorite-apps"

## set favorite apps in dock
echo "
[org/gnome/shell]
favorite-apps = [ 'firefox.desktop', 'chromium-browser.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'geogebra-classic.desktop', 'vlc.desktop', 'gnome-terminal.desktop', 'win7.desktop', 'win10.desktop', 'yelp.desktop' ]

" > ${DATABASE_DIR}/${SYSTEM_DB_SUBDIR}/${FILE}

dconf update
