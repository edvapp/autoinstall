#!/bin/bash

# from https://help.ubuntu.com/community/LDAPClientAuthentication
# write pam configuration file for creating homedirs on the fly
echo "
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0077 skel=/etc/skel
" >>  /usr/share/pam-configs/my_mkhomedir

pam-auth-update --package --force my_mkhomedir


