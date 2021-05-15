#!/bin/bash


## write groups, to which LDAP - users are added on login
# dialout: for using arduino programming software
# vboxusers: to access USB via virtualbox
##

echo "
*;*;*;Al0000-2400;dialout,vboxusers
" >> /etc/security/group.conf

# write pam configuration file for allowing LDAP - users adding to groups on login
echo "
Name: activate /etc/security/group.conf
Default: yes
Priority: 900
Auth-Type: Primary
Auth:
        required                        pam_group.so use_first_pass
" >> /usr/share/pam-configs/my_groups

pam-auth-update --package --force my_groups


systemctl restart nscd.service 
