#!/bin/bash

CONF_DIR="/etc/gdm3/PreSession"
CONF_FILE="Default"
HOOKED_SCRIPT="blockWWWForTestees.sh"


# Copy File with DISABLE-ENABLE-Code to /usr/local/bin
cp  files/$HOOKED_SCRIPT /usr/local/bin/
chmod 750 /usr/local/bin/$HOOKED_SCRIPT

# START to block WWW on login
# Add Hook $HOOKED_SCRIPT to File /etc/gdm3/PreSession/Default
echo "
# Hook to /usr/local/bin/$HOOKED_SCRIPT
/bin/bash /usr/local/bin/$HOOKED_SCRIPT start
" >> $CONF_DIR/$CONF_FILE

# STOP to block WWW on logout
# Add Hook $HOOKED_SCRIPT to File /etc/gdm3/PostSession/Default
# Replace original /etc/gdm3/PostSession/Default
CONF_DIR="/etc/gdm3/PostSession"
echo "
# Hook to /usr/local/bin/$HOOKED_SCRIPT
/bin/bash /usr/local/bin/$HOOKED_SCRIPT stop
" > $CONF_DIR/$CONF_FILE

