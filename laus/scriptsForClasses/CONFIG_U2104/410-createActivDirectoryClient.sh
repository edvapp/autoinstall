#!/bin/bash


## "START: INSTALLATION OF SAMBA4 CLIENT"
## set variable for your domain
SAMBA4_DNS_DOMAIN_NAME="app.tsn"
SAMBA4_REALM_DOMAIN_NAME="APP.TSN"
SAMBA4_DOMAIN="APP"
SAMBA4_AD_DNS_STATIC_IP="10.0.0.19"
#SAMBA4_TIMEZONE="Europe/Vienna"

DOMAIN_JOIN_USER="domain_join_user"
DOMAIN_JOIN_USER_PASSWORD="Passw0rd"

export DEBIAN_FRONTEND=noninteractive

## TODO: Im Augenblick HOSTNAME.app.tsn HOSTNAME => richtig, aber falsche Domain
## "CHECK /etc/hosts FOR FQDN & STATIC IP"
## check if FQDN exists in /etc/hosts
#if [ $(hostname) = $(hostname --fqdn) ];
#then       
#        file="/etc/hosts"
#        if ! [ -f ${file}".original" ];
#        then
#	        cp ${file} ${file}".original"
#        fi
#        updatetime=$(date +%Y%m%d-%T)
#        newfile=${file}".laus."${updatetime}
#        cp ${file} ${newfile}
#       
#        sed -e "{
#            /$(hostname)/ s/$(hostname)/$(hostname).${SAMBA4_DNS_DOMAIN_NAME} $(hostname)/
#        }" -i ${file} 
#fi

## TODO: if needed
## set STATIC IP in /etc/hosts
#file="/etc/hosts"
#if ! [ -f ${file}".original" ];
#then
#        cp ${file} ${file}".original"
#fi
#updatetime=$(date +%Y%m%d-%T)
#newfile=${file}".laus."${updatetime}
#cp ${file} ${newfile}
## /bin/bash change-IP-etc_hosts.sh

## INSTALL PACKAGES
## from samba - wiki: acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user
## acl, attr: exteded acls
## bind9-dnsutils: dig, nslookup
## to get Domain Users/Groups onto Fileserver to set Directory/File Permissions: libnss-winbind
## to enable local logins for Domain Users: libpam-winbind
## to preset computer-accounts: adcli
apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils libnss-winbind libpam-winbind adcli 

## STOP all services
systemctl stop nmbd
systemctl stop winbind
systemctl stop smbd

## STOP AND DISABLE systemd-resolved & SET AD DOMAIN CONTROLLER IP AS NAMESERVER IN NEW $file"
## TODO: check if needed, when we install with right DNS = AD Server
systemctl stop systemd-resolved
systemctl disable systemd-resolved

file=/etc/resolv.conf
if ! [ -f ${file}".original" ];
then
        mv ${file} ${file}".original"
fi

echo "nameserver ${SAMBA4_AD_DNS_STATIC_IP}
search ${SAMBA4_DNS_DOMAIN_NAME}
"> ${file}

## RESTART NETPLAN
netplan apply
 
### WRITE NEW CLEAN KERBEROS CONFIGURATION FILES
file="/etc/krb5.conf"
if ! [ -f ${file}".original" ];
then
        mv ${file} ${file}".original"
fi

echo "
[logging]
        default = FILE:/var/log/krb5libs.log

[libdefaults]
         default_realm = ${SAMBA4_REALM_DOMAIN_NAME}
         dns_lookup_realm = true
         dns_lookup_kdc = true
         #ticket_lifetime = 24h
         #renew_lifetime = 7d
         rdns = false
         forwardable = yes

" > ${file}

## WRITE NEW /etc/samba/smb.conf
file="/etc/samba/smb.conf"
if ! [ -f ${file}".original" ];
then
        mv ${file} ${file}".original"
fi

echo "
[global]
   workgroup = ${SAMBA4_DOMAIN}
   security = ADS
   realm = ${SAMBA4_REALM_DOMAIN_NAME}

   # we MUST set winbind use default domain = yes 
   # to drop ${SAMBA4_DOMAIN} before username listed
   # by winbindd to keep idmapd working for NFS4 & krb5
   # ${SAMBA4_DOMAIN}\username instead username will break 
   # name -> uid -> name for idmapd
   winbind use default domain = yes
   winbind refresh tickets = Yes
   vfs objects = acl_xattr
   map acl inherit = Yes
   store dos attributes = Yes
   
   # Setting the default back end is mandatory.
   # Default ID mapping configuration for local BUILTIN accounts
   # and groups on a domain member. The default (*) domain:
   # - must not overlap with any domain ID mapping configuration!
   # - must use a read-write-enabled back end, such as tdb.
   idmap config * : backend = tdb
   idmap config * : range = 3000-7999
   
   # - You must set a DOMAIN backend configuration
   # idmap config for the ${SAMBA4_DOMAIN} domain
   idmap config ${SAMBA4_DOMAIN} : backend = ad
   idmap config ${SAMBA4_DOMAIN} : schema_mode = rfc2307
   # we have to avoid the internal used range: 3 000 0000 - 4 000 000 
   # and start with    5 000 000
   # and end with: 2 147 483 647 = 2^31 - 1
   # for uids created from IPs: 10.3.12.105 -> 2 003 012 105 have to stay beyond 10.147. !
   # https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Domain_Member
   idmap config ${SAMBA4_DOMAIN} : range = 5000000-2147483647
   idmap config ${SAMBA4_DOMAIN} : unix_nss_info = yes
   idmap config ${SAMBA4_DOMAIN} : unix_primary_group = yes

   # If you are creating a new smb.conf on an unjoined machine and add these lines, 
   # a keytab will be created during the join:
   dedicated keytab file = /etc/krb5.keytab
   kerberos method = secrets and keytab
   
   # To disable printing completely, add these lines:
   load printers = no
   printing = bsd
   printcap name = /dev/null
   disable spoolss = yes
   
" > ${file}

## CONNECT client via nsswitch.conf and winbind to domain ${SAMBA4_DOMAIN}
file="/etc/nsswitch.conf"
if ! [ -f ${file}".original" ];
then
        cp ${file} ${file}".original"
fi
updatetime=$(date +%Y%m%d-%T)
newfile=${file}".laus."${updatetime}
cp ${file} ${newfile}

sed -e "{
	/^passwd:/ s/$/ winbind/
}" -e "{
	/^group:/ s/$/ winbind/
}" -i ${file}


## START smbd winbind services
systemctl start smbd
systemctl start winbind
## DISABLE nmbd
systemctl disable nmbd

## enable automatic home-directory creation
pam-auth-update --enable mkhomedir

## SET TIMEZONE to ${SAMBA4_TIMEZONE}
#timedatectl set-timezone ${SAMBA4_TIMEZONE}

## "join domain ${SAMBA4_REALM_DOMAIN_NAME}"
# adcli join -v --one-time-password=secret1234 ${SAMBA4_REALM_DOMAIN_NAME}
# looks like adcli works only with sssd without problems :-( ??
# so we use net ads on servers
# server will also be added to DNS, if it does not exist. error message if allready in DNS
# but due to UNIX attributes all AD - clients should be added with special script an AD - server anyway
net ads join -U ${DOMAIN_JOIN_USER}@${SAMBA4_DNS_DOMAIN_NAME}%${DOMAIN_JOIN_USER_PASSWORD}

