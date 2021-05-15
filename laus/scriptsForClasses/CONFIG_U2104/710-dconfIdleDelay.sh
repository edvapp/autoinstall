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

FILE="org.gnome.desktop.session.idle-delay"

## set Unity idle-delay from 300 to 600 
## means: screen will turn black after 10min
echo "
[org/gnome/desktop/session]
idle-delay=600

" > ${DATABASE_DIR}/${SYSTEM_DB_SUBDIR}/${FILE}

dconf update
