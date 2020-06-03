#!/bin/bash

# https://help.ubuntu.com/community/LDAPClientAuthentication
# https://help.ubuntu.com/lts/serverguide/openldap-server.html

#apt-get -y update

# has to be one line
export DEBIAN_FRONTEND=noninteractive 

apt-get -y -q install ldap-auth-client nscd libpam-cracklib

# Nscd is a daemon that provides a cache for the most common name service requests
# pam_cracklib.so <= needed for passwordchange!!


# configuration of /etc/ldap.conf is normalli done by:
# dpkg-reconfigure ldap-auth-config  when you install the package ldap-auth-client.deb
#
# because we skiped the standard configuration we create our /etc/ldap.conf 
# with security special cn=ldapread,dc=app,dc=net in /etc/ldap.conf 
# we use ldapread instead admin-user, because ldapread just has read-rights instead all rights.

file="/etc/ldap.conf"
if ! [ -f $file".original" ];
then
	cp $file $file".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=$file".laus."$updatetime
cp $file $newfile

### START SET PARAMETER FOR LDAP in /etc/ldap.conf ###

## set ldap server name in /etc/ldap.conf
sed '/#host 127.0.0.1/ s/#host 127.0.0.1/host ldap01 ldap02/' -i $file

## disable connection uri in /etc/ldap.conf
sed '/uri ldapi/ s/uri ldapi/#uri ldapi/' -i $file

## set ldap base for APP in /etc/ldap.conf
sed '/base dc=example,dc=net/ s/base dc=example,dc=net/base dc=app,dc=net/' -i $file

## set ldap read_bind_dn in /etc/ldap.conf
sed -e "{
	/#binddn cn=proxyuser,dc=padl,dc=com/ s/#binddn cn=proxyuser,dc=padl,dc=com/binddn cn=ldapread,dc=app,dc=net/
}" -e "{
	/#bindpw/ s/#bindpw secret/bindpw nurlesen/
}" -i $file

## disable rootbinddn in /etc/ldap.conf
sed '/rootbinddn/ s/rootbinddn/#rootbinddn/' -i $file

### STOP SET PARAMETER FOR LDAP in /etc/ldap.conf ###


# Set right parameters in /etc/nsswitch.conf to
# passwd:         files systemd ldap
# group:          files systemd ldap
# shadow:         files ldap

file="/etc/nsswitch.conf"
if ! [ -f $file".original" ];
then
	cp $file $file".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=$file".laus."$updatetime
cp $file $newfile

sed -e "{
	/^passwd:/ s/$/ ldap/
}" -e "{
	/^group:/ s/$/ ldap/
}" -e "{
	/^shadow:/ s/$/ ldap/
}" -i $file

