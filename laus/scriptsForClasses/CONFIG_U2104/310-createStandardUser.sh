#!/bin/bash

# add Standard User "user" with primary group 1000 (=worker) used as dummy - group
# group 1000 will be changed to 2000 (=Default Users) coming from LDAP
# LDAP - connetion has to be setup frist

# create group nopasswdlogin for user "user"
# later pam will enable nopasswdlogin for user
groupadd nopasswdlogin

# for writing to arduino board user has to be in group dialout
useradd --uid 3101 --groups nopasswdlogin,dialout --comment "user" --base-dir /home --create-home --shell /bin/bash user


# from https://help.ubuntu.com/community/LDAPClientAuthentication
# write pam configuration file for creating homedirs on the fly
echo "
Name: activate nopasswdlogin
Default: yes
Priority: 900
Auth-Type: Primary
Auth:
	sufficient pam_succeed_if.so user ingroup nopasswdlogin
" >>  /usr/share/pam-configs/my_nopasswdlogin

pam-auth-update --package --force my_nopasswdlogin

